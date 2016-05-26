//
//  BackTableVC.swift
//  WifiRC
//
//  Created by Ludgero Bento on 02/08/15.
//  Copyright © 2015 Ludgero Bento. All rights reserved.
//

import Foundation
import UIKit

class BackTableVC: UITableViewController, GCDAsyncUdpSocketDelegate {
    var TableArray = [String]()
    
    //enviar comandos
    let IP = "192.168.4.1"
    let PORT:UInt16 = 53
    var socket:GCDAsyncUdpSocket!
    //
    //variaveis bateria
    var bateria=""
    var stringLength = 0
    var bateria2 = ""
    var bateria3 = 0
    var bateriaStat = Float(0)
    //var bateriaStatFinal = Int()
    //
    
    var alerta = Int()
    
    var i = 0
    
    override func viewDidLoad() {
        TableArray = ["Setas","Acelarometro","About"]
        setupConnection()
    }
    
    
    //funçao para estabelecer conecçao
    func setupConnection() {
        socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        do{    try self.socket.connectToHost(IP, onPort: PORT)}catch { print(error)}
    }
    //
    //receber dados/ estado da bateria
    func udpSocket(sock: GCDAsyncUdpSocket!, didReceiveData data: NSData!, fromAddress address: NSData!,      withFilterContext filterContext: AnyObject!)  {
        print("incoming message: \(data)");
        bateria = "\(data)"
        stringLength = bateria.characters.count//tamanho string assim quando nao tem V no adc nao crasha
        if(stringLength == 8)
        {
            let index1 = bateria.startIndex.advancedBy(2)//advance(bateria.startIndex, 2)
            let index2 = bateria.startIndex.advancedBy(4)//advance(bateria.startIndex, 4)
            let index3 = bateria.startIndex.advancedBy(6)//advance(bateria.startIndex, 6)
            bateria2 = String(bateria[index1]) + String(bateria[index2]) + String(bateria[index3])
            
            let bateria3: Int? = Int(bateria2)//int
            
            //ajustar a precentagem de bateria
            //int(floor)- converte de float para int
            if(bateria3 <= 335)
            {
                bateriaStat = Float(bateria3! - 333)/200.0 // regularizaçao para obter valores entre 0-1
                if(bateriaStat <= (1.0))
                {
                    bateriaStat = 0.0
                }
            }
            if(bateria3 >= 499)
            {
                bateriaStat = Float(bateria3! - 305)/200.0 // regularizaçao para obter valores entre 0-1
                if(bateriaStat >= (100.0))
                {
                    bateriaStat = 100.0
                }
            }
            
            if (bateria3 > 335 && bateria3 < 499)
            {
                bateriaStat = Float(bateria3! - 320)/200.0 // regularizaçao para obter valores entre 0-1
            }
            
            //
            //mostrar bat%
            //Pbat.setProgress(bateriaStat, animated: true)
            //bat.text = String(Int(floor(bateriaStat * 100))) + "%";
            //return Int(floor(bateriaStat * 100))
            //bateriaStatFinal = Int(floor(bateriaStat * 100))
        } else{}
        
    }
    //
    // funçao enviar string por udp, controlo do carro
    func send(message:String) -> Int {
        i=1
        let data = message.dataUsingEncoding(NSUTF8StringEncoding)
        socket.sendData(data, withTimeout: 2, tag: 0)
        do { try socket.receiveOnce() }catch {}//receber bat
        i=0
        return i
    }
    //
    //funçoes de verificaçao da ligaçao entre tele e ESP
    func udpSocket(sock: GCDAsyncUdpSocket!, didConnectToAddress address: NSData!) {
        //print("didConnectToAddress");
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didNotConnect error: NSError!) {
        //print("didNotConnect \(error)")
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didSendDataWithTag tag: Int) {
        //print("didSendDataWithTag")
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didNotSendDataWithTag tag: Int, dueToError error: NSError!) {
        //print("didNotSendDataWithTag")
        setupConnection()
    }
    //

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableArray.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(TableArray[indexPath.row], forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = TableArray[indexPath.row]
        
        return cell
    }
    
    func EstadoBat() -> Float{
        return bateriaStat
    }
    //envia C a para controlo no esp em caso de desconeçao
    
    @IBAction func luz(sender: AnyObject) {
        
        if (sender.selectedSegmentIndex == 0 && i==0){
           i=send("ONl")

        }
        if (sender.selectedSegmentIndex == 1 && i==0){
            i=send("OFFl")
        }
    
    }
    
    
}
