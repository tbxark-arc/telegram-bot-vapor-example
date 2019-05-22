//
//  BilibiliBotController.swift
//  App
//
//  Created by Tbxark on 2019/5/11.
//

import Vapor
import TelegramBotAPI

class BilibiliBotController: TelegramBotController {
    
    let mid: String
    
    init(mid: String, token: String) {
        self.mid = mid
        super.init(name: "Bilibili:\(mid)", token: token)
    }
    
    private func updated() {
        let video = "https://space.bilibili.com/ajax/member/getSubmitVideos?mid=\(mid)&pagesize=1&tid=0&page=1&keyword=&order=pubdate"
        let count = "https://api.bilibili.com/x/space/acc/info?mid=\(mid)&jsonp=jsonp"
    }
}
