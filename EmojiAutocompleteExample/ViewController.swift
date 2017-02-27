import UIKit
import EmojiKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var t: UITextView!
    
    fileprivate let fetcher = EmojiFetcher()

    
    var emojis = [Emoji]() {
        didSet {
            tableView.reloadData()
            tableView.isHidden = emojis.count == 0
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.isHidden = true
    
    }
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emojis.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let emoji = emojis[indexPath.row]
        cell.textLabel?.text = emoji.character
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        t.replaceWordAtCurrentCursorPositionWithWord(word: emojis[indexPath.row].character)
    }
}


extension ViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        emojis = []
        fetcher.cancelFetches()
        
        guard let word = textView.wordAtCurrentCursorLocation(),
            word.characters.count >= 4 || word.hasPrefix(":") else {
                return
        }
        
        
        fetcher.query(word) { [weak self] results in
            self?.emojis = results
        }
    }
}


