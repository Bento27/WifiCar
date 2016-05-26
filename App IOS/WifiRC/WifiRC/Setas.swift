//
//  Setas.swift
//  WifiRC
//
//  Created by Ludgero Bento on 02/08/15.
//  Copyright © 2015 Ludgero Bento. All rights reserved.
//

import Foundation


class Setas: UIViewController {
    //declarar a outra class para poder usar as funçoes dela nesta
    let back = BackTableVC()
    //
    //inicializaçao objectos interface
    @IBOutlet var bat: UILabel!
    @IBOutlet var Pbat: UIProgressView!
    @IBOutlet var imagem: UIImageView!
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
    var direita=0
    var esquerda=0
    var frente=0
    var tras=0
    var i=0
    //
    
    //abrir menu
    @IBAction func menus(sender: UIButton) {
        if(frente == 0 && tras == 0 && direita == 0 && esquerda == 0)
        {
            revealViewController().revealToggleAnimated(true)
            back.send("OFF")
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
        //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        if(back.alerta==0){
        //alerta wifi
        let alertController = UIAlertController (title: "Connection!", message: "Be sure your device is connected to WifiCar", preferredStyle: .Alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .Default) { (_) -> Void in
            let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        let cancelAction = UIAlertAction(title: "Continue", style: .Default, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil);
        //
            back.alerta=1
            }

        imagem.hidden = true//esconder imagem de bloqueio quando abre menu
        
        back.setupConnection()
        
        
        //Update bateria interface a casa 5s
        _ = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector("estadobat"), userInfo: nil, repeats: true)
        //

    }
    //mostrar bat
    func estadobat(){
        Pbat.setProgress(back.bateriaStat, animated: true)
        bat.text = String(Int(floor(back.bateriaStat * 100))) + "%";
    }
    //
    //botoes de controlo
    @IBAction func cimaON(sender: AnyObject) {
        if(i==0 && tras==0) {i=1; frente=1; i=back.send(ONf) }
    }
    
    @IBAction func cimaOFF(sender: AnyObject) {
        if(i==0 && tras==0) {i=1; frente=0;  i=back.send(OFFf)}
    }
    
    @IBAction func trasON(sender: AnyObject) {
        if(i==0 && frente==0) {i=1; tras=1;  i=back.send(ONt)}
    }
    
    @IBAction func trasOFF(sender: AnyObject) {
        if(i==0 && frente==0) {i=1; tras=0;  i=back.send(OFFt)}
    }
    
    @IBAction func direitaON(sender: AnyObject) {
        if(i==0 && esquerda==0) {i=1; direita=1;   i=back.send(ONd)}
    }
    
    @IBAction func direitaOFF(sender: AnyObject) {
         if(i==0 && esquerda==0) {i=1; direita=0;   i=back.send(OFFd)}
    }
    
    @IBAction func esquerdaON(sender: AnyObject) {
        if(i==0 && direita==0) {i=1; esquerda=1;   i=back.send(ONe)}
    }
    
    @IBAction func esquerdaOFF(sender: AnyObject) {
        if(i==0 && direita==0) {i=1; esquerda=0;   i=back.send(OFFe)}
    }
    //

}