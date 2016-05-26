//
//  Acelarometro.swift
//  WifiRC
//
//  Created by Ludgero Bento on 02/08/15.
//  Copyright © 2015 Ludgero Bento. All rights reserved.
//

import Foundation
import CoreMotion

class Acelarometro: UIViewController {
    
    @IBOutlet var Pbat: UIProgressView!
    @IBOutlet var bat: UILabel!
    
    @IBOutlet var Laccel: UILabel!
    @IBOutlet var imagem: UIImageView!
  
    //declarar a outra class para poder usar as funçoes dela nesta
    let back = BackTableVC()
    //
    
   
    lazy var motionManager = CMMotionManager()
    
    //acelarometro
    var y:Double = 0.0
    var dir = 0
    var esq = 0
    var meio = 0
    var dirLast = 0
    var esqLast = 0
    var meioLast = 0
    var sms = ""
    //
    //variaveis controlo carro
    var ONt = "ONt"
    var OFFt = "OFFt"
    var ONf = "ONf"
    var OFFf = "OFFf"
    var ONe = "ONe"
    var OFFe = "OFFe"
    var ONd = "ONd"
    var OFFd = "OFFd"
    var frente=0
    var tras=0
    var i=0
    //abrir menu
    @IBAction func menus(sender: UIButton) {
        if(frente == 0 && tras == 0)
        {
            revealViewController().revealToggleAnimated(true)
            back.send("OFF")
            
            //para updates de acelarometro quando nao se esta no controde de accel
            motionManager.stopAccelerometerUpdates()
            
            //imagem que bloqueia o front view e quando carrega fecha menu lateral
            imagem.hidden = false
            // blur imagem de block
            let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
            let blurView = UIVisualEffectView(effect: darkBlur)
            blurView.frame = imagem.bounds
            imagem.addSubview(blurView)
            //
            imagem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "fecharMenu"))
            //
        }
        }
    //
    //funçao para fechar menu lateral e carregar a mesma view
    func fecharMenu(){
        revealViewController().revealToggleAnimated(true)//funçao fecha e abre true e so para ter animaçao de deslizar ao abrir ou fechar
        viewDidLoad()
    }
    //
    override func viewDidLoad() {
        
        imagem.hidden = true//esconder imagem de bloqueio quando abre menu
        
        //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        //self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer()) //funçao swipe e abrir menu
        //self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "ola"))
        
        back.setupConnection()
        
        if motionManager.accelerometerAvailable{
            let queue = NSOperationQueue()
            motionManager.startAccelerometerUpdatesToQueue(queue, withHandler:
                {data, error in
                    
                    guard let data = data else{
                        return
                    }
                   //enviar direçao os if evitao o loop constante de envio de ON ou OFF assim so envia 1x de cada
                    self.y = data.acceleration.y
                   
                    if (self.y > 0.4){
                        self.dir = 1
                        self.meio = 0
                    }
                    
                    if (self.y < -0.4){
                        self.esq = 1
                        self.meio = 0
                    }
                    
                    if (self.y < 0.41 && self.y > -0.41){
                        self.meio = 1
                        self.dir = 0
                        self.esq = 0
                    }
                    
                    if (self.i==0 && self.esq == 1 && self.esq != self.esqLast && self.dir==0){
                        self.i = 1
                        self.i = self.back.send(self.ONe)
                        //print("envia esq")
                        self.esqLast = self.esq
                        self.meioLast = 0
                        self.sms = "< Tilt to steer   "
                    }
                    
                    if (self.i==0 && self.dir == 1 && self.dir != self.dirLast && self.esq==0){
                        self.i = 1
                        self.i = self.back.send(self.ONd)
                        //print("envia dir")
                        self.dirLast = self.dir
                        self.meioLast = 0
                        self.sms = "   Tilt to steer > "
                    }
                    
                    if (self.i==0 && self.meio == 1 && self.meio != self.meioLast){
                        self.i = 1
                        self.back.send(self.OFFd)
                        self.i = self.back.send(self.OFFe)
                        //print("envia meio")
                        self.meioLast = self.meio
                        self.dirLast = 0
                        self.esqLast = 0
                        self.sms = "   Tilt to steer   "
                    }
                    //
                    
                }
            )
        } else {
            print("Accelerometer is not available")
        }
        
        //Update bateria interface a casa 5s
        _ = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector("estadobat"), userInfo: nil, repeats: true)
        //
        //Update mendagens direcao
         _ = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("mostaL"), userInfo: nil, repeats: true)
        //
       }
    
    //mostrar bat
    func estadobat(){
        Pbat.setProgress(back.bateriaStat, animated: true)
        bat.text = String(Int(floor(back.bateriaStat * 100))) + "%";
    }
    //
    //mensagem dirçao
    func mostaL()
    {
        Laccel.text = sms
    }
    //
    // setas frente/tras
    @IBAction func frenteON(sender: AnyObject) {
        if(i==0 && tras==0) {i=1; frente=1; i=back.send(ONf) }
    }
    @IBAction func frenteOFF(sender: AnyObject) {
        if(i==0 && tras==0) {i=1; frente=0;  i=back.send(OFFf)}
    }
    @IBAction func trasON(sender: AnyObject) {
         if(i==0 && frente==0) {i=1; tras=1;  i=back.send(ONt)}
    }
    @IBAction func trasOFF(sender: AnyObject) {
        if(i==0 && frente==0) {i=1; tras=0;  i=back.send(OFFt)}
    }
    //
  
  
  
}

