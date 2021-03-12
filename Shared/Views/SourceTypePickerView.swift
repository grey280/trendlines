//
//  SourceTypePickerView.swift
//  trendlines
//
//  Created by Grey Patterson on 2/21/21.
//

import SwiftUI

fileprivate struct SourceTypePickerItemView: View {
    let type: DataSourceType
    @Binding var selectedType: DataSourceType
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        // TODO: Needs some accessibility hinting to indicate activate state
        HStack {
            Text(type.title)
            Spacer()
            if (type == selectedType) {
                Image(systemName: "checkmark")
            }
        }.onTapGesture {
            selectedType = type
            presentationMode.wrappedValue.dismiss()
        }
    }
}

    

struct SourceTypePickerView: View {
    @Binding var sourceType: DataSourceType
    
//    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List {
            Section(header: Text("Custom")) {
                SourceTypePickerItemView(title: Text("Data Set"), type: .entries, selectedType: $sourceType)
            }
            Section(header: Text("Body")) {
                SourceTypePickerItemView(title: Text("Resting Heart Rate"), type: .health(.body(.restingHeartRate)), selectedType: $sourceType)
                SourceTypePickerItemView(title: Text("Heart Rate Variability"), type: .health(.body(.heartRateVariability)), selectedType: $sourceType)
                SourceTypePickerItemView(title: Text("Heart Rate"), type: .health(.body(.heartRate)), selectedType: $sourceType)
                SourceTypePickerItemView(title: Text("Body Mass"), type: .health(.body(.bodyWeight)), selectedType: $sourceType)
                SourceTypePickerItemView(title: Text("Lean Body Mass"), type: .health(.body(.leanBodyMass)), selectedType: $sourceType)
                SourceTypePickerItemView(title: Text("Body Fat Percentage"), type: .health(.body(.bodyFatPercentage)), selectedType: $sourceType)
            }
            Section(header: Text("Activity")) {
                SourceTypePickerItemView(title: Text("Calories Burned"), type: .health(.activity(.activeEnergy)), selectedType: $sourceType)
                SourceTypePickerItemView(title: Text("Walk/Run Distance"), type: .health(.activity(.walkRunDistance)), selectedType: $sourceType)
                SourceTypePickerItemView(title: Text("Swim Distance"), type: .health(.activity(.swimDistance)), selectedType: $sourceType)
                SourceTypePickerItemView(title: Text("Cycling Distance"), type: .health(.activity(.cyclingDistance)), selectedType: $sourceType)
                SourceTypePickerItemView(title: Text("Flights Climbed"), type: .health(.activity(.flightsClimbed)), selectedType: $sourceType)
                SourceTypePickerItemView(title: Text("Steps"), type: .health(.activity(.steps)), selectedType: $sourceType)
                SourceTypePickerItemView(title: Text("Stand Hours"), type: .health(.activity(.standHours)), selectedType: $sourceType)
                SourceTypePickerItemView(title: Text("Exercise Time"), type: .health(.activity(.workoutTime)), selectedType: $sourceType)
            }
            Section(header: Text("Nutrition")) {
                SourceTypePickerItemView(title: Text("Calories"), type: .health(.nutrition(.calories)), selectedType: $sourceType)
                SourceTypePickerItemView(title: Text("Water"), type: .health(.nutrition(.water)), selectedType: $sourceType)
                SourceTypePickerItemView(title: Text("Carbohydrates"), type: .health(.nutrition(.carbohydrates)), selectedType: $sourceType)
                SourceTypePickerItemView(title: Text("Fat"), type: .health(.nutrition(.fat)), selectedType: $sourceType)
                SourceTypePickerItemView(title: Text("Protein"), type: .health(.nutrition(.protein)), selectedType: $sourceType)
                SourceTypePickerItemView(title: Text("Caffeine"), type: .health(.nutrition(.caffeine)), selectedType: $sourceType)
                SourceTypePickerItemView(title: Text("Sugar"), type: .health(.nutrition(.sugar)), selectedType: $sourceType)
            }
            Section(header: Text("Vitamins")) {
                Group {
                    SourceTypePickerItemView(title: Text("Vitamin A"), type: .health(.nutrition(.vitamin(.vitaminA))), selectedType: $sourceType)
                    SourceTypePickerItemView(title: Text("Thiamin"), type: .health(.nutrition(.vitamin(.thiamin))), selectedType: $sourceType)
                    SourceTypePickerItemView(title: Text("Riboflavin"), type: .health(.nutrition(.vitamin(.riboflavin))), selectedType: $sourceType)
                    SourceTypePickerItemView(title: Text("Niacin"), type: .health(.nutrition(.vitamin(.niacin))), selectedType: $sourceType)
                    SourceTypePickerItemView(title: Text("Pantothenic Acid"), type: .health(.nutrition(.vitamin(.pantothenicAcid))), selectedType: $sourceType)
                    SourceTypePickerItemView(title: Text("Vitamin B6"), type: .health(.nutrition(.vitamin(.vitaminB6))), selectedType: $sourceType)
                    SourceTypePickerItemView(title: Text("Biotin"), type: .health(.nutrition(.vitamin(.biotin))), selectedType: $sourceType)
                }
                Group {
                    SourceTypePickerItemView(title: Text("Vitamin B12"), type: .health(.nutrition(.vitamin(.vitaminB12))), selectedType: $sourceType)
                    SourceTypePickerItemView(title: Text("Vitamin C"), type: .health(.nutrition(.vitamin(.vitaminC))), selectedType: $sourceType)
                    SourceTypePickerItemView(title: Text("Vitamin D"), type: .health(.nutrition(.vitamin(.vitaminD))), selectedType: $sourceType)
                    SourceTypePickerItemView(title: Text("Vitamin E"), type: .health(.nutrition(.vitamin(.vitaminE))), selectedType: $sourceType)
                    SourceTypePickerItemView(title: Text("Vitamin K"), type: .health(.nutrition(.vitamin(.vitaminK))), selectedType: $sourceType)
                    SourceTypePickerItemView(title: Text("Folate"), type: .health(.nutrition(.vitamin(.folate))), selectedType: $sourceType)
                }
            }
            Section(header: Text("Minerals")) {
                SourceTypePickerItemView(title: Text("Calcium"), type: .health(.nutrition(.mineral(.calcium))), selectedType: $sourceType)
                SourceTypePickerItemView(title: Text("Chloride"), type: .health(.nutrition(.mineral(.chloride))), selectedType: $sourceType)
                SourceTypePickerItemView(title: Text("Iron"), type: .health(.nutrition(.mineral(.iron))), selectedType: $sourceType)
                SourceTypePickerItemView(title: Text("Magnesium"), type: .health(.nutrition(.mineral(.magnesium))), selectedType: $sourceType)
                SourceTypePickerItemView(title: Text("Phosphorus"), type: .health(.nutrition(.mineral(.phosphorus))), selectedType: $sourceType)
                SourceTypePickerItemView(title: Text("Potassium"), type: .health(.nutrition(.mineral(.potassium))), selectedType: $sourceType)
                SourceTypePickerItemView(title: Text("Sodium"), type: .health(.nutrition(.mineral(.sodium))), selectedType: $sourceType)
                SourceTypePickerItemView(title: Text("Zinc"), type: .health(.nutrition(.mineral(.zinc))), selectedType: $sourceType)
            }
            Section(header: Text("Micronutrients")) {
                SourceTypePickerItemView(title: Text("Calcium"), type: .health(.nutrition(.micronutrient(.chromium))), selectedType: $sourceType)
                SourceTypePickerItemView(title: Text("Copper"), type: .health(.nutrition(.micronutrient(.copper))), selectedType: $sourceType)
                SourceTypePickerItemView(title: Text("Iodine"), type: .health(.nutrition(.micronutrient(.iodine))), selectedType: $sourceType)
                SourceTypePickerItemView(title: Text("Manganese"), type: .health(.nutrition(.micronutrient(.manganese))), selectedType: $sourceType)
                SourceTypePickerItemView(title: Text("Molybdenum"), type: .health(.nutrition(.micronutrient(.molybdenum))), selectedType: $sourceType)
                SourceTypePickerItemView(title: Text("Selenium"), type: .health(.nutrition(.micronutrient(.selenium))), selectedType: $sourceType)
            }
        }//.onChange(of: sourceType) {
        //    presentationMode.wrappedValue.dismiss()
        //}
    }
}


struct SourceTypePickerView_Previews: PreviewProvider {
    static var previews: some View {
        SourceTypePickerView(sourceType: .constant(DataSourceType.entries))
    }
}
