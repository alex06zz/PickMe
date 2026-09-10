import SwiftUI

struct PickMeLogoView: View {
    var body: some View {
        VStack(spacing: 8) {
            
            HStack(spacing: 0) {
                Text("P")
                
                // Custom "i" with a gradient dot
                VStack(spacing: 3) {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.pink, .purple, .blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 12, height: 12)
                    
                    RoundedRectangle(cornerRadius: 3)
                        .fill(.white)
                        .frame(width: 9, height: 26)
                }
                .frame(width: 16, height: 50)
                
                Text("ckMe")
            }
            .font(.system(size: 54, weight: .bold))
            .foregroundColor(.white)
            
            Text("Make the choice easy")
                .font(.system(size: 17, weight: .medium, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            .white,
                            .white.opacity(0.65)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        PickMeLogoView()
    }
}
