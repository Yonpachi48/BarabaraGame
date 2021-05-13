//
//  GameViewController.swift
//  BarabaraGame
//
//  Created by Yudai Takahashi on 2021/05/07.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet var imgView1: UIImageView!    //上の画像
    @IBOutlet var imgView2: UIImageView!    //真ん中の画像
    @IBOutlet var imgView3: UIImageView!    //下の画像
    
    @IBOutlet var resultLabel: UILabel!     //スコアを表示するラベル
    
    var timer: Timer!    //画像を動かすタイマー
    var score: Int = 1000   //スコアの値
    let defalts: UserDefaults = UserDefaults.standard //スコアを保持する関数
    
    let width: CGFloat = UIScreen.main.bounds.size.width   //画面幅
    
    var positionX: [CGFloat] = [0.0, 0.0, 0.0]  //画像の位置の配列
    
    var dx: [CGFloat] = [1.0, 0.8, -2.0]    //画像を動かす幅の配列
    
    
    func start(){
        resultLabel.isHidden = true //結果ラベルを見えなくする
        
        timer = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(self.up), userInfo: nil, repeats: true)
        timer.fire()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        positionX = [width/2, width/2, width/2]  //画像の位置を画面幅の中心にする
        self.start()    //startメソッドを呼び出す
        // Do any additional setup after loading the view.
    }
    
    @objc func up(){
        for i in 0..<3 {
            //端に来たら動かす向きを逆にする
            if positionX[i] > width || positionX[i] < 0{
                dx[i] = dx[i] * (-1)
            }
            positionX[i] += dx[i]   //画像の位置をdx分ずらす
        }
        imgView1.center.x = positionX[0]    //上の画像をずらした位置に移動させる
        imgView2.center.x = positionX[1]    //真ん中の画像をずらした位置に移動させる
        imgView3.center.x = positionX[2]    //下の画像をずらした位置に移動させる
    }
    
    @IBAction func stop(){
        if timer.isValid == true {  //もしタイマーが動いていたら
            timer.invalidate()      //タイマーを止める(無効にする)
        }
        
        for i in 0..<3 {
            score = score - abs(Int(width/2 - positionX[i]))*2  //スコアの計算をする
        }
        resultLabel.text = "Socre : " + String(score)   //結果ラベルにスコアを表示する
        resultLabel.isHidden = false    //結果ラベルを隠さない
        
        let highScore1: Int = defalts.integer(forKey: "score1")
        let highScore2: Int = defalts.integer(forKey: "score2")
        let highScore3: Int = defalts.integer(forKey: "score3")
        
        if score > highScore1 { //ランキング1位の記録を更新したら
            defalts.set(score, forKey: "score1")    //"score1"というキーでscoreを保存
            defalts.set(highScore1, forKey: "score2")   //"score2"というキーでhighscore1(元1位の記録)を保存
            defalts.set(highScore2, forKey: "score3")   //"score3"というキーでhighscore2(元2位の記録)を保存
        } else if score > highScore2 {  //ランキング2位の記録を更新したら
            defalts.set(score, forKey: "score2")    //"score2"というキーでscoreを保存
            defalts.set(highScore2, forKey: "score3")   //"score3"というキーでhighscore2(元2位の記録)を保存
        } else if score > highScore3 {  //ランキング3位の記録を更新したら
            defalts.set(score, forKey: "score3")    //"score3"というキーでscoreを保存
        }
            
    }
    
    @IBAction func retry() {
        score = 1000    //スコアの値をリセットする
        positionX = [width/2, width/2, width/2] //画像の位置を真ん中に戻す
        if timer.isValid == false {
            self.start()    //スターメソッドを呼び戻す
        }
    }
    
    @IBAction func toTop() {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
