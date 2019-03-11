//
//  SubtitlesViewController.swift
//  Quick Caption
//
//  Created by Blue on 3/10/19.
//  Copyright © 2019 Bright. All rights reserved.
//

import Cocoa
import AVKit

class SubtitlesViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, NSTextFieldDelegate {

    @IBOutlet weak var transcribeTextField: NSTextField!
    @IBOutlet weak var resultTableView: NSTableView!
    weak var episode: EpisodeProject!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func configurateSubtitleVC() {
        self.resultTableView.delegate = self
        self.resultTableView.dataSource = self
        transcribeTextField.delegate = self
        episode = AppDelegate.movieVC()?.episode
    }

    // MARK: - TextField Controls
    func control(_ control: NSControl, textShouldBeginEditing fieldEditor: NSText) -> Bool {
        if (episode.player == nil) {
            return true
        }

        if (control == transcribeTextField) {
            episode.player?.pause()
            if let last = episode.arrayForCaption.last {
                last.endingTime = episode.player?.currentTime()
            }
        }
        return true
    }

    @IBAction func captionTextFieldDidChange(_ sender: NSTextField) {
        if (episode.player == nil) {
            sender.stringValue = ""
            _ = Helper.dialogOKCancel(question: "A video is required before adding captions.", text: "Please open a video first, then add captions to the video.")
            return
        }
        if (sender == transcribeTextField) {
            episode.player?.play()
            if sender.stringValue == "" {
                if let last = episode.arrayForCaption.last {
                    last.startingTime = episode.player?.currentTime()
                }
            } else {
                if let last = episode.arrayForCaption.last {
                    last.caption = sender.stringValue
                }
                sender.stringValue = ""
                var new: CaptionLine!
                if let lastEndingTime = episode.arrayForCaption.last?.endingTime {
                    new = CaptionLine.init(caption: "", startingTime: lastEndingTime, endingTime: nil)
                } else {
                    new = CaptionLine.init(caption: "", startingTime: episode.player?.currentTime(), endingTime: nil)
                }
                episode.arrayForCaption.append(new)
            }
            self.resultTableView.reloadData()
            if resultTableView.numberOfRows > 0 {
                self.resultTableView.scrollRowToVisible(resultTableView.numberOfRows - 1)
            }
        }
    }

    // MARK: - Table View Delegate/Data Source
    func numberOfRows(in tableView: NSTableView) -> Int {
        return episode.arrayForCaption.count
    }


    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cell: NSTableCellView?

        let correspondingCaption = episode.arrayForCaption[row]
        if tableColumn?.title == "Start Time" {
            cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "StartTimeCell"), owner: self) as? NSTableCellView
            cell?.textField?.stringValue = "\(correspondingCaption.startingTimeString)"
        } else if tableColumn?.title == "End Time" {
            cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "EndTimeCell"), owner: self) as? NSTableCellView
            cell?.textField?.stringValue = "\(correspondingCaption.endingTimeString)"
        } else {
            cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CaptionCell"), owner: self) as? NSTableCellView
            if let cap = correspondingCaption.caption {
                cell?.textField?.stringValue = cap
            } else {
                cell?.textField?.stringValue = ""
            }
            cell?.textField?.isEditable = true
        }
        return cell
    }


    @IBAction func captionChanged(_ sender: NSTextField) {
        let row = resultTableView.row(for: sender)
        episode.arrayForCaption[row].caption = sender.stringValue
    }

}