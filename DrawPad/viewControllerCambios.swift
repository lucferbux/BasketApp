//
//  viewControllerCambios.swift
//  DrawPad
//
//  Created by lucas fernández on 28/10/15.
//  Copyright © 2015 Ray Wenderlich. All rights reserved.
//

import UIKit

class viewControllerCambios: UIViewController, writeValueBackDelegate {
    
    //var
    var numero = 0
    
    var tiempo = 1
    
    var timer = NSTimer()
    
    var countMin = 0
    
    var countSeg = 0
    
    var countDec = 0
    
    var statePlay = true
    
    var equipo = [Array](count: 8, repeatedValue: ["Pivot Izq", "Pivot Der", "Alero Izq", "Alero Der", "Base"])
    
    var posicionJugador = [String]()
    
    var posicion = 1
    
    var cuartoSeleccionado = 0
    
    
    //outlets
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var minutes: UILabel!
    
    @IBOutlet weak var seconds: UILabel!
    
    //@IBOutlet weak var miliseconds: UILabel!
    
    @IBOutlet weak var pivotIzq: UIButton!
    
    @IBOutlet weak var pivotDer: UIButton!
    
    @IBOutlet weak var aleroIzq: UIButton!

    @IBOutlet weak var aleroDer: UIButton!
    
    
    //Actions
    @IBOutlet weak var base: UIButton!
    
    @IBAction func abrirTabla(sender: UIButton){
        let pos = sender.tag
        NSUserDefaults.standardUserDefaults().setObject(equipo, forKey: "equipo")
        NSUserDefaults.standardUserDefaults().setObject(cuartoSeleccionado, forKey: "cuarto")
        
        NSUserDefaults.standardUserDefaults().synchronize()
         self.performSegueWithIdentifier("tabla", sender: pos)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "tabla"{
            if let navigation = segue.destinationViewController as? UINavigationController{
                if let tableroVC = navigation.topViewController as? TableViewControllerLista{
                    if let estado = sender as? Int{
                        tableroVC.delegate = self
                        tableroVC.pos = estado
                    }
                }
            }
        }
    }
    
    

    @IBAction func play(sender: AnyObject) {
        
        if statePlay {
            timer = NSTimer.scheduledTimerWithTimeInterval(1/100, target: self, selector: #selector(viewControllerCambios.updateDecTime), userInfo: nil, repeats: true)
            statePlay = false
        }else{
            timer.invalidate()
            statePlay = true
        }
        
    }
    
    @IBAction func stop(sender: AnyObject) {
        timer.invalidate()
        countMin = 0
        countSeg = 0
        countDec = 0
        seconds.text = "00"
        minutes.text = "00"
        statePlay = true
    }
    
    
   
    
    @IBAction func cambiarCuarto(sender: UIButton){
        let cuarto = sender.tag
        cuartoSeleccionado = cuarto
        cambiarVista(cuarto)
    }
    
    
    
    
    //functions
    
    override func viewDidLoad() {
        
        pivotIzq.layer.cornerRadius = 0.5 * pivotIzq.bounds.size.width
        pivotIzq.layer.borderWidth = 2
        pivotIzq.layer.borderColor = UIColor.blackColor().CGColor
        
        pivotDer.layer.cornerRadius = 0.5 * pivotIzq.bounds.size.width
        pivotDer.layer.borderWidth = 2
        pivotDer.layer.borderColor = UIColor.blackColor().CGColor
        
        aleroIzq.layer.cornerRadius = 0.5 * pivotIzq.bounds.size.width
        aleroIzq.layer.borderWidth = 2
        aleroIzq.layer.borderColor = UIColor.blackColor().CGColor
        
        aleroDer.layer.cornerRadius = 0.5 * pivotIzq.bounds.size.width
        aleroDer.layer.borderWidth = 2
        aleroDer.layer.borderColor = UIColor.blackColor().CGColor
        
        base.layer.cornerRadius = 0.5 * pivotIzq.bounds.size.width
        base.layer.borderWidth = 2
        base.layer.borderColor = UIColor.blackColor().CGColor
        
        /*playButton.layer.borderWidth = 2
         playButton.layer.borderColor = UIColor.blackColor().CGColor
         
         pauseButton.layer.borderWidth = 2
         pauseButton.layer.borderColor = UIColor.blackColor().CGColor*/
        
        super.viewDidLoad()
        if let equipoAux = NSUserDefaults.standardUserDefaults().valueForKey("equipo") as? [[String]] {
            equipo = equipoAux
        }
        if let cuartoAux = NSUserDefaults.standardUserDefaults().valueForKey("cuarto") as? Int {
            cuartoSeleccionado = cuartoAux
        }
        cambiarVista(cuartoSeleccionado)
        
        // Do any additional setup after loading the view.
    }
    
    func writeValueBack(value: [String]) {
        posicionJugador = value
    }

    
    override func viewDidAppear(animated: Bool) {

        if let equipoAux = NSUserDefaults.standardUserDefaults().valueForKey("equipo") as? [[String]] {
            equipo = equipoAux
        }
        if let cuartoAux = NSUserDefaults.standardUserDefaults().valueForKey("cuarto") as? Int {
            cuartoSeleccionado = cuartoAux
        }
        
        if posicionJugador.count >= 2{
            posicion = Int(posicionJugador[1])!
        }
        cambiarJugador(posicionJugador)
    }
    
    func updateDecTime(){
        if countDec < 99{
            countDec += 1
        }else{
            if countSeg < 59{
                countSeg += 1
            }else{
                countMin += 1
                if countMin < 10{
                    minutes.text = "0\(countMin)" //cambiar
                }else{
                    minutes.text = "\(countMin)"
                }
                countSeg = 0
            }
            
            if countSeg < 10{
                seconds.text = "0\(countSeg)"
            }else{
                seconds.text = "\(countSeg)"
            }
            
            countDec = 0
        }
        
        if countDec < 10{
            //miliseconds.text = "0\(countDec)"
        }else{
            //miliseconds.text = "\(countDec)"
        }
        
    }

    func cambiarJugador(equipoJugado: [String]){
        
        if !posicionJugador.isEmpty{
        
        equipo[cuartoSeleccionado][posicion - 1] = posicionJugador[0]
            
        pivotIzq.setTitle(equipo[cuartoSeleccionado][0], forState: UIControlState.Normal)
        pivotDer.setTitle(equipo[cuartoSeleccionado][1], forState: UIControlState.Normal)
        aleroIzq.setTitle(equipo[cuartoSeleccionado][2], forState: UIControlState.Normal)
        aleroDer.setTitle(equipo[cuartoSeleccionado][3], forState: UIControlState.Normal)
        base.setTitle(equipo[cuartoSeleccionado][4], forState: UIControlState.Normal)
        }
        
        }
    
    func cambiarVista(cuarto: Int){
        pivotIzq.setTitle(equipo[cuarto][0], forState: UIControlState.Normal)
        pivotDer.setTitle(equipo[cuarto][1], forState: UIControlState.Normal)
        aleroIzq.setTitle(equipo[cuarto][2], forState: UIControlState.Normal)
        aleroDer.setTitle(equipo[cuarto][3], forState: UIControlState.Normal)
        base.setTitle(equipo[cuarto][4], forState: UIControlState.Normal)
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
