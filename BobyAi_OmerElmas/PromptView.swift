

import SwiftUI

struct PromptView: View {
    @State private var selectedStyle = ImageStyle.allCases[0]
    
    @State private var promptText = ""
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Image Generation")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                Spacer()
                Text("Select a style")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)
                
                GeometryReader {reader in
                    ScrollView(.horizontal , showsIndicators: false){
                        HStack {
                            ForEach(ImageStyle.allCases , id: \.self) { imageStyle in
                                Button {
                                    selectedStyle = imageStyle
                                } label: {
                                    Image(imageStyle.rawValue)
                                        .resizable()
                                        .background(.blue)
                                        .scaledToFill()
                                        .frame(width: reader.size.width * 0.4 , height: reader.size.width * 0.4 * 1.4)
                                    
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 20).stroke(.yellow ,
                                                                                      lineWidth: imageStyle == selectedStyle ? 3 : 0)
                                        }
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                }
                            }
                        }
                    }
                }
                Spacer()
                Text("Enter your prompt")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)
                TextEditor(text: $promptText)
                    .scrollContentBackground(.hidden)
                    .padding()
                    .background(.gray.opacity(0.15))
                    .cornerRadius(20)
                    .foregroundColor(.white)
                    .tint(.yellow)
                VStack{
                    NavigationLink {
                        GeneratorView(viewModel: .init(prompt: promptText, selectedStyle: selectedStyle))
                    } label : {
                        Text("Generate")
                            .foregroundColor(.white)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width - 130, height: 58)
                            .background(.blue)
                            .clipShape(Capsule())
                        
                    }
                }
                .frame(maxWidth:.infinity)
            }
            .padding()
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button {
                        dismiss()
                    } label:{
                        Image (systemName: "xmark")
                    }
                }
            }
        }
    }
}

struct PromptView_Previews: PreviewProvider {
    static var previews: some View {
        PromptView()
    }
}
