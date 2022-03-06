//
//  IMCView.swift
//  IMC
//
//  Created by Regina on 03/03/22.
//

import Foundation
import UIKit

class IMCView {
    //Control imperial / métrico
    var control = true
    func controlBool(estatura: String, peso: String, inches: String)->(Double,String,Double){
        if control
        {   //En métrico
            return calculo(estatura: estatura, peso: peso)
        }
        else{
            //Pasar a métrico para realizar cálculos
            let imperialP = imperialToMetricPeso(peso: peso)
            let imperialA = imperialToMetricEstatura(estatura: estatura, inches: inches)
            return calculo(estatura: String(imperialA), peso: String(imperialP))
        }
    }
    //Conversión de unidades métricas a imperiales para el peso
    func metricToImperialPeso(peso: String)->Double{
        //Obtener peso
        var kg = Double(peso)
        //Declarar libras
        var lb = 0.0
        if let kgAux = Double(peso){
            kg = Double(kgAux)
        }
        else{
        return -1
        }
        //Conversion
        if((kg!<=300)&&(kg!>=20)) //Validar
        {
            lb = kg! * 2.205
        }
        else //No realizar conversión
        {
            return -1
        }
        return lb
    }
    
    //Conversión de unidades imperiales a métricas para el peso
    func imperialToMetricPeso(peso: String)->Double{
        //Obtener peso
        var lb = Double(peso)
        //Declarar kilogramos
        var kg = 0.0
        if let lbAux = Double(peso){
            lb = Double(lbAux)
        }
        else{
        return -1
        }
        //Conversion
        if((lb!<=661)&&(lb!>=44)) //Validar
        {
            kg = lb! / 2.205
        }
        else //No realizar conversión
        {
            return -1
        }
        return kg
    }
    
    //Conversión de unidades métricas a imperiales para la estatura
    func metricToImperialEstatura(estatura: String, inches: String)->(Double,Double){
        //Obtener altura cm
        var cm = Double(estatura)
        if let cmAux = Double(estatura){
            cm = Double(cmAux)
        }
        else{
        return (-1,-1)
        }
        //Declaraciones
        var pies = 0.0
        var inch = 0.0
        var totalIn = 0.0
        var auxPies = 0
        //Conversion
        if((cm!<=270)&&(cm!>=55)) //Validar
        {
            totalIn = cm! / 2.54
            auxPies = Int(totalIn / 12)
            inch = (totalIn - Double(12 * auxPies))
            pies = Double(auxPies)
        }
        else //No realizar conversión
        {
            return (-1,-1)
        }
        return (pies,inch)
    }
    
    //Conversión de unidades imperiales a métricas para el peso
    func imperialToMetricEstatura(estatura: String, inches: String)->(Double){
        //Obtener altura ft in
        var auxInches = Double(inches)
        if let inchesAux = Double(inches){
            auxInches = Double(inchesAux)
        }
        else{
        return -1
        }
        var pies = Double(estatura)
        if let piesAux = Double(estatura){
            pies = Double(piesAux)
        }
        else{
        return -1
        }
        //Declarar cm
        var cm = 0.0
        //Conversion
        if((pies!<=9)&&(pies!>=2)) //Validar
        {
            cm = Double((pies! * 30.48) + (auxInches! * 2.54))
        }
        else //No realizar conversión
        {
            return -1
        }
        return cm
    }
    
    //Cálculo de IMC, IMC Prime y Categoría
    func calculo(estatura: String, peso: String)->(Double, String, Double){
        //En métrico
        var cm = Double(estatura)
        var kg = Double(peso)
        if let pesoAux = Double(peso){
        kg = Double(pesoAux)
        }
        else{
        return (-1,"-1",-1)
        }
        if let estaturaAux = Double(estatura){
            cm = Double(estaturaAux)
        }
        else{
            return (-1,"-1",-1)
        }
        if(((kg!<=300)&&(kg!>=20))&&((cm!<=270)&&(cm!>=55)))
        {
            var imc = 0.0
            var m = 0.0
            var categoria = ""
            var imcPrime = 0.0
            //Operaciones IMC, IMCPrime
            m = cm! / 100
            imc = (kg!)/(m * m)
            imcPrime = imc / 25
            //Categoria en base al IMC
            if(imc<18.5){
                categoria = "Peso insuficiente"
            }
            if((imc>=18.5)&&(imc<25)){
                categoria = "Normal"
            }
            if((imc>=25)&&(imc<30)){
                categoria = "Sobrepeso"
            }
            if((imc>=30)&&(imc<35)){
                categoria = "Obesidad I"
            }
            if((imc>=35)&&(imc<40)){
                categoria = "Obesidad II"
            }
            if(imc>=40){
                categoria = "Obesidad III"
            }
            return(imc, categoria, imcPrime)
        }
        return (-1,"-1",-1)
    }
}

