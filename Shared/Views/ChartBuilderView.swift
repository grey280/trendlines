//
//  ChartBuilderView.swift
//  trendlines
//
//  Created by Grey Patterson on 2/21/21.
//

import SwiftUI

struct ChartBuilderView: View {
    
    init(_ onSave: @escaping (Chart) -> Void) {
        self.onSave = onSave
        self._chart = State(initialValue: Chart(id: nil, sortNo: 1, source1: DataSource(sourceType: .entries, title: "", color: .gray, chartType: nil), source2: nil))
    }
    init(chart: Chart, _ onSave: @escaping (Chart) -> Void) {
        self.onSave = onSave
        self._chart = State(initialValue: chart)
    }
    
    let onSave: (Chart) -> Void
    
    @State var chart: Chart
    
    var body: some View {
        Form {
            Section(header: Text("Left")) {
                SourceBuilderView(source: $chart.source1)
            }
            Toggle("Comparison?", isOn: Binding(get: {
                chart.source2 != nil
            }, set: { (val) in
                if (val) {
                    chart.source2 = DataSource(sourceType: .entries, title: "", color: .gray, chartType: nil)
                } else {
                    chart.source2 = nil
                }
            }))
            if let source2 = Binding($chart.source2) {
                Section(header: Text("Right")) {
                    SourceBuilderView(source: source2)
                }
            }
        }
    }
}

struct SourceBuilderView: View {
    @Binding var source: DataSource
    
    var body: some View {
        TextField("Title", text: $source.title)
        ColorPicker("Color", selection: $source.color)
        SourceTypePicker(sourceType: $source.sourceType)
    }
}

struct SourceTypePicker: View {
    @Binding var sourceType: DataSourceType
    
    var body: some View {
        Picker("Data Type", selection: $sourceType) {
            Section(header: Text("Custom")) {
                Text("Data Set").tag(DataSourceType.entries)
            }
            Section(header: Text("Body")) {
                Text("Resting Heart Rate").tag(DataSourceType.health(.body(.restingHeartRate)))
                Text("Heart Rate Variability").tag(DataSourceType.health(.body(.heartRateVariability)))
                Text("Heart Rate").tag(DataSourceType.health(.body(.heartRate)))
                Text("Body Mass").tag(DataSourceType.health(.body(.bodyWeight)))
                Text("Lean Body Mass").tag(DataSourceType.health(.body(.leanBodyMass)))
                Text("Body Fat Percentage").tag(DataSourceType.health(.body(.bodyFatPercentage)))
            }
            Section(header: Text("Activity")) {
                Text("Calories Burned").tag(DataSourceType.health(.activity(.activeEnergy)))
                Text("Walk/Run Distance").tag(DataSourceType.health(.activity(.walkRunDistance)))
                Text("Swim Distance").tag(DataSourceType.health(.activity(.swimDistance)))
                Text("Cycling Distance").tag(DataSourceType.health(.activity(.cyclingDistance)))
                Text("Flights Climbed").tag(DataSourceType.health(.activity(.flightsClimbed)))
                Text("Steps").tag(DataSourceType.health(.activity(.steps)))
                Text("Stand Hours").tag(DataSourceType.health(.activity(.standHours)))
                Text("Exercise Time").tag(DataSourceType.health(.activity(.workoutTime)))
            }
            Section(header: Text("Nutrition")) {
                Text("Calories").tag(DataSourceType.health(.nutrition(.calories)))
                Text("Water").tag(DataSourceType.health(.nutrition(.water)))
                Text("Carbohydrates").tag(DataSourceType.health(.nutrition(.carbohydrates)))
                Text("Fat").tag(DataSourceType.health(.nutrition(.fat)))
                Text("Protein").tag(DataSourceType.health(.nutrition(.protein)))
                Text("Caffeine").tag(DataSourceType.health(.nutrition(.caffeine)))
                Text("Sugar").tag(DataSourceType.health(.nutrition(.sugar)))
            }
            Section(header: Text("Vitamins")) {
                Group {
                    Text("Vitamin A").tag(DataSourceType.health(.nutrition(.vitamin(.vitaminA))))
                    Text("Thiamin").tag(DataSourceType.health(.nutrition(.vitamin(.thiamin))))
                    Text("Riboflavin").tag(DataSourceType.health(.nutrition(.vitamin(.riboflavin))))
                    Text("Niacin").tag(DataSourceType.health(.nutrition(.vitamin(.niacin))))
                    Text("Pantothenic Acid").tag(DataSourceType.health(.nutrition(.vitamin(.pantothenicAcid))))
                    Text("Vitamin B6").tag(DataSourceType.health(.nutrition(.vitamin(.vitaminB6))))
                    Text("Biotin").tag(DataSourceType.health(.nutrition(.vitamin(.biotin))))
                }
                Group {
                    Text("Vitamin B12").tag(DataSourceType.health(.nutrition(.vitamin(.vitaminB12))))
                    Text("Vitamin C").tag(DataSourceType.health(.nutrition(.vitamin(.vitaminC))))
                    Text("Vitamin D").tag(DataSourceType.health(.nutrition(.vitamin(.vitaminD))))
                    Text("Vitamin E").tag(DataSourceType.health(.nutrition(.vitamin(.vitaminE))))
                    Text("Vitamin K").tag(DataSourceType.health(.nutrition(.vitamin(.vitaminK))))
                    Text("Folate").tag(DataSourceType.health(.nutrition(.vitamin(.folate))))
                }
            }
            Section(header: Text("Minerals")) {
                Text("Calcium").tag(DataSourceType.health(.nutrition(.mineral(.calcium))))
                Text("Chloride").tag(DataSourceType.health(.nutrition(.mineral(.chloride))))
                Text("Iron").tag(DataSourceType.health(.nutrition(.mineral(.iron))))
                Text("Magnesium").tag(DataSourceType.health(.nutrition(.mineral(.magnesium))))
                Text("Phosphorus").tag(DataSourceType.health(.nutrition(.mineral(.phosphorus))))
                Text("Potassium").tag(DataSourceType.health(.nutrition(.mineral(.potassium))))
                Text("Sodium").tag(DataSourceType.health(.nutrition(.mineral(.sodium))))
                Text("Zinc").tag(DataSourceType.health(.nutrition(.mineral(.zinc))))
            }
            Section(header: Text("Micronutrients")) {
                Text("Calcium").tag(DataSourceType.health(.nutrition(.micronutrient(.chromium))))
                Text("Copper").tag(DataSourceType.health(.nutrition(.micronutrient(.copper))))
                Text("Iodine").tag(DataSourceType.health(.nutrition(.micronutrient(.iodine))))
                Text("Manganese").tag(DataSourceType.health(.nutrition(.micronutrient(.manganese))))
                Text("Molybdenum").tag(DataSourceType.health(.nutrition(.micronutrient(.molybdenum))))
                Text("Selenium").tag(DataSourceType.health(.nutrition(.micronutrient(.selenium))))
            }
        }
    }
}

struct ChartBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        ChartBuilderView() { _ in }
    }
}
