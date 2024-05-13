//
//  HistoryViewController.swift
//  LanzamientoMoneda
//
//  Created by Johnne Lemand on 12/05/24.
//

import UIKit
import DGCharts
import ProjectUI

class HistoryViewController: UIViewController {
    
    private let numberOfCrosses: Int
    private let numberOfFaces: Int
    
    private let historyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.text = "Historial"
        return label
    }()
    
    private let chartView: PieChartView = {
        let chart = PieChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
    
    init(numberOfCrosses: Int, numberOfFaces: Int) {
        self.numberOfCrosses = numberOfCrosses
        self.numberOfFaces = numberOfFaces
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        setupConstraints()
        updateChart()
    }
    
    private func setupViews() {
        view.addSubview(chartView)
        view.addSubview(historyLabel)
    }
    
    private func setupConstraints() {
        historyLabel
            .pin(.top, to: view.safeAreaLayoutGuide, constant: 20)
            .pin(.centerX, to: view.centerXAnchor)
        
        
        // Restricciones para la gráfica
        NSLayoutConstraint.activate([
            chartView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chartView.topAnchor.constraint(equalTo: historyLabel.bottomAnchor, constant: 40), // Separación de 40 puntos desde la etiqueta de historial
            chartView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8), // 80% del ancho de la vista
            chartView.heightAnchor.constraint(equalTo: chartView.widthAnchor) // Gráfica cuadrada
        ])
    }
    
    private func updateChart() {
        let total = numberOfCrosses + numberOfFaces
        
        // Calcular los porcentajes
        let crossesPercentage = Double(numberOfCrosses) / Double(total)
        let facesPercentage = Double(numberOfFaces) / Double(total)
        
        // Ajustar los porcentajes si es necesario para que la suma sea 100%
        let adjustmentFactor = 1 / (crossesPercentage + facesPercentage)
        let adjustedCrossesPercentage = crossesPercentage * adjustmentFactor
        let adjustedFacesPercentage = facesPercentage * adjustmentFactor
        
        // Actualizar la gráfica con los porcentajes ajustados
        let dataSet = PieChartDataSet(entries: [
            ChartDataEntry(x: 0, y: adjustedCrossesPercentage, data: "Cruz"),
            ChartDataEntry(x: 1, y: adjustedFacesPercentage, data: "Cara")
        ], label: "Resultados")
        
        dataSet.colors = [UIColor.systemRed, UIColor.systemBlue]
        chartView.data = PieChartData(dataSet: dataSet)
    }
}
