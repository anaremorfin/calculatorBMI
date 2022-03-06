//
//  ViewController.swift
//  IMC
//
//  Created by Regina on 01/03/22.
//

import UIKit

class ViewController: UIViewController{
    
    //Vinculaciones
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var peso: UITextField!
    @IBOutlet weak var estatura: UITextField!
    @IBOutlet weak var inches: UITextField!
    @IBOutlet weak var calcular: UIButton!
    @IBOutlet weak var imc: UILabel!
    @IBOutlet weak var categoria: UILabel!
    @IBOutlet weak var imcPrime: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var registro: UITextView!
    @IBOutlet weak var titleIMC: UILabel!
    
    //Conexion a Vista
    let modelo=IMCView()
    
    //Control para unidades (métrico e imperial)
    @IBAction func segmentedControl(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        { //Unidades métricas
        case 0:
            modelo.control = true
            if(peso.text == ""){ //Sin texto escrito
                defaultMetricPeso()
            }
            else{
                escondeTeclado()
                let temp = Double(modelo.imperialToMetricPeso(peso: peso.text!)) //Conversión de imperial a métrico
                if (temp == -1){
                    showAlert(titulo: "Error", mensaje: "Fuera de rango")
                }
                else{
                    peso.text = String(format: "%.2f", temp)
                }
            }
            if(estatura.text == ""){
                defaultMetricEstatura() //Sin texto escrito
                inches.isHidden = true //No mostrar TextField de pulgadas
                
            }
            else{
                escondeTeclado()
                inches.isHidden = true //Mostrar TextField de pulgadas
                let temp = Double(modelo.imperialToMetricEstatura(estatura: estatura.text!, inches: inches.text!)) //Conversión de imperial a métrico
                if (temp == -1){
                    showAlert(titulo: "Error", mensaje: "Fuera de rango")
                }
                else{
                    estatura.text = String(format: "%.2f",temp)
                }
            }
            
        case 1: //Unidades imperiales
            modelo.control = false
            if(peso.text == ""){
                defaultImperialPeso() //Sin texto escrito
                inches.isHidden = false
            }
            else{
                escondeTeclado()
                let temp = Double(modelo.metricToImperialPeso(peso: peso.text!)) //Conversión de métrico a imperial
                inches.isHidden = false
                if (temp == -1){
                    showAlert(titulo: "Error", mensaje: "Fuera de rango")
                }
                else{
                    peso.text = String(format: "%.2f", temp)
                }
            }
            if(estatura.text == ""){
                inches.isHidden = false //No mostrar TextField de pulgadas
                defaultImperialEstaturaFt() //Sin texto escrito
                defaultImperialEstaturaIn() //Sin texto escrito
            }
            else{
                escondeTeclado()
                let estaturaValue: Double
                let inchesValue: Double
                inches.isHidden = false //No mostrar TextField de pulgadas
                (estaturaValue,inchesValue) = modelo.metricToImperialEstatura(estatura: estatura.text!, inches: inches.text!) //Conversión de métrico a imperial
                if (estaturaValue == -1){
                    showAlert(titulo: "Error", mensaje: "Fuera de rango")
                }
                else{
                    estatura.text = String(format: "%.2f", estaturaValue)
                }
                if (inchesValue == -1){
                    showAlert(titulo: "Error", mensaje: "Fuera de rango")
                }
                else{
                    inches.text = String(format: "%.2f",inchesValue)
                }
            }
            
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //Colocar placeholders default
    func defaultMetricPeso(){
        peso.placeholder = "Peso en kg"
    }
    func defaultMetricEstatura(){
        estatura.placeholder = "Estatura en cm"
    }
    func defaultImperialPeso(){
        peso.placeholder = "Peso en lb"
    }
    func defaultImperialEstaturaFt(){
        estatura.placeholder = "Estatura en ft"
    }

    func defaultImperialEstaturaIn(){
        inches.placeholder = "in"
    }
    
    //Calculo de IMC, IMC Prime y Categoría
    @IBAction func botonCalcular(_ sender: Any) {
        escondeTeclado()
        let imcValue: Double
        let imcPrimeValue: Double
        let categoriaLabel: String
        //Llamar función para calculo
        (imcValue,categoriaLabel, imcPrimeValue) = modelo.controlBool(estatura: estatura.text!, peso: peso.text!, inches: inches.text!)
        if(imcValue == -1)
        {
            showAlert(titulo: "Error", mensaje: "Valores introducidos inválidos")
        }
        else{
            //Texto de IMC
            imc.text = String(format: "%.2f", imcValue)
            //Colores de categoría dependiendo su texto
            if categoriaLabel == "Peso insuficiente"{
                categoria.textColor = UIColor.blue
                categoria.text = String(categoriaLabel)
            }
            if categoriaLabel == "Normal"{
                categoria.textColor = UIColor.systemBlue
                categoria.text = String(categoriaLabel)
            }
            if categoriaLabel == "Sobrepeso"{
                categoria.textColor = UIColor.yellow
                categoria.text = String(categoriaLabel)
            }
            if categoriaLabel == "Obesidad I"{
                categoria.textColor = UIColor.orange
                categoria.text = String(categoriaLabel)
            }
            if categoriaLabel == "Obesidad II"{
                categoria.textColor = UIColor.red
                categoria.text = String(categoriaLabel)
            }
            if categoriaLabel == "Obesidad III"{
                categoria.textColor = UIColor.purple
                categoria.text = String(categoriaLabel)
            }
            //Texto de IMC Prime
            imcPrime.text = String(format: "%.2f", imcPrimeValue)
            //Llama a función de registro
            showRegister(imcValue: imc.text!, categoria: categoria.text!, imcPrimeValue: imcPrime.text!)
        }
    }
    
    //Esconder teclado para los TextFields posibles
    func escondeTeclado(){
        peso.resignFirstResponder()
        estatura.resignFirstResponder()
        inches.resignFirstResponder()
    }
    
    //Registra las consultas con fecha y hora, IMC, IMC Prime y categoría
    private func showRegister(imcValue: String, categoria: String, imcPrimeValue: String){
        let now = Date() //Fecha y hora actual
        let dateFormatter = DateFormatter() //Formato
        dateFormatter.dateFormat = "dd/MM/yy HH:mm" //Mi formato
        let fechaHora = dateFormatter.string(from: now) //Aplicar formato
        let insert = fechaHora + " // IMC:" + imcValue + " // IMC Prime:" + imcPrimeValue + " // Categoría:" + categoria + "\n" //Concatenar
        registro.insertText(insert) //Insertar
        registro.isEditable = false //No se puede editar por el usuario
        //Quitar texto para nueva consulta
        peso.text = ""
        estatura.text = ""
        inches.text = ""
    }
    
    //Desplegar alerta
    func showAlert(titulo: String, mensaje: String){
    let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
    NSLog("ERR")
    }))
    self.present(alert, animated: true, completion: nil)
        peso.text = ""
        estatura.text = ""
        inches.text = ""
    }
}




