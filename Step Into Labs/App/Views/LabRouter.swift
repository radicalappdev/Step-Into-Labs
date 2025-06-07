//
//  LabRouter.swift
//  Step Into Labs
//
//  Created by Joseph Simpson on 10/3/24.
//

import SwiftUI

struct LabRouter: View {
    @Binding var route: String?

    @ViewBuilder
    var body: some View {
        switch route {
        case "Lab 001": Lab001()
        case "Lab 002": Lab002()
        case "Lab 003": Lab003()
        case "Lab 004": Lab004()
        case "Lab 005": Lab005()
        case "Lab 006": Lab006()
        case "Lab 007": Lab007()
        case "Lab 008": Lab008()
        case "Lab 009": Lab009()
        case "Lab 010": Lab010()
        case "Lab 011": Lab011()
        case "Lab 012": Lab012()
        case "Lab 013": Lab013()
        case "Lab 014": Lab014()
        case "Lab 015": Lab015()
        case "Lab 016": Lab016()
        case "Lab 017": Lab017()
        case "Lab 018": Lab018()
        case "Lab 019": Lab019()
        case "Lab 020": Lab020()
        case "Lab 021": Lab021()
        case "Lab 022": Lab022()
        case "Lab 023": Lab023()
        case "Lab 024": Lab024()
        case "Lab 025": Lab025()
        case "Lab 026": Lab026()
        case "Lab 027": Lab027()
        case "Lab 028": Lab028()
        case "Lab 029": Lab029()
        case "Lab 030": Lab030()
        case "Lab 031": Lab031()
        case "Lab 032": Lab032()
        case "Lab 033": Lab033()
        case "Lab 034": Lab034()
        case "Lab 035": Lab035()
        case "Lab 036": Lab036()
        case "Lab 037": Lab037()
        case "Lab 038": Lab038()
        case "Lab 039": Lab039()
        case "Lab 040": Lab040()
        case "Lab 041": Lab041()
        case "Lab 042": Lab042()
        case "Lab 043": Lab043()
        case "Lab 044": Lab044()
        case "Lab 045": Lab045()
        case "Lab 046": Lab046()
        case "Lab 047": Lab047()
        case "Lab 048": Lab048()
        case "Lab 049": Lab049()
        case "Lab 050": Lab050()
        case "Lab 051": Lab051()
        case "Lab 052": Lab052()
        case "Lab 053": Lab053()
        case "Lab 054": Lab054()
        case "Lab 055": Lab055()
        case "Lab 056": Lab056()
        case "Lab 057": Lab057()
        case "Lab 058": Lab058()
        case "Lab 059": Lab059()
        



        case .none, .some:

            VStack {
                Text("No View could be found for " + (route ?? ""))
                    .font(.largeTitle)
                    .padding(12)
            }
            .background(.red)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
    }
}
