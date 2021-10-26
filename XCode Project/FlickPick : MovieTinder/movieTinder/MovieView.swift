//
//  ContentView.swift
//  movieTinder
//
//  Created by Colby Beach on 3/19/21.
//

import SwiftUI
import Firebase
import FirebaseFirestore

private var db = Firestore.firestore()
private var userStore = UserStoreFunctions()


struct MovieView: View {
    
        
    @ObservedObject var movieList = MovieViewModel()
    @State var updater = ""
    @State var showingSheet = true
    
    @State var showingMoviePoster = false
    @State var moviePoster = ""
    
    func getCurrentMovie() -> Dictionary<String, String>{
                

        let likedList = userStore.getLikedList(index: userStore.getFireStoreUserIndex(uid: (Auth.auth().currentUser?.uid) ?? ""))
        let dislikedList = userStore.getDislikedList(index: userStore.getFireStoreUserIndex(uid: (Auth.auth().currentUser?.uid) ?? ""))

        
        var title = ""
        var desc = ""
        var poster = "https://i.ibb.co/yRrfLwf/Flick-Pick-logos-transparent.png"
        var rating = ""
        var year = ""
        
        //Handles beginning exception
        if movieList.movies.count > 0 {
            
            var x = 0;
            
            while x < movieList.movies.count {
                
                let randomMovieNum = Int.random(in: 0..<movieList.movies.count)

                
                if(!likedList.contains(movieList.movies[randomMovieNum].Title)){
                    
                    if(!dislikedList.contains(movieList.movies[randomMovieNum].Title)){
                        title = movieList.movies[randomMovieNum].Title
                        desc = movieList.movies[randomMovieNum].Plot
                        poster = movieList.movies[randomMovieNum].Poster
                        rating = movieList.movies[randomMovieNum].imdbRating
                        year = "(" + movieList.movies[randomMovieNum].Year! + ")"
                        
                        break;
                    }
                }
                
                x += 1
                
                if(x >= movieList.movies.count){
                    title = "No More Movies Left!!"
                    desc = "Check Back Later!"
                }
                
            }
        
        }
        
        let dict = ["title": title, "desc": desc, "rating": rating, "year": year, "poster": poster]
        
        return dict
        

    }
    
    
   
    var body: some View {
        
        var currentMovie = getCurrentMovie()
        
        ZStack{
            
                VStack{
                    
                    Button {
                        
                        moviePoster = currentMovie["poster"]!
                        showingMoviePoster.toggle()
                        
                        
                    } label: {
                        let url = URL(string: currentMovie["poster"]!)
                        let data = try? Data(contentsOf: url!)

                        if let imageData = data {
                            let moviePoster = UIImage(data: imageData)
                                
                                    
                            Image(uiImage: moviePoster!)
                                    .resizable()
                                    .frame(width: 600, height: 400)
                                    .clipped()
                        } //Image URL
                    }
                    
                    .sheet(isPresented: $showingMoviePoster) {
                        MoviePosterView(moviePosterSend: $moviePoster)
                    }


                   

                    ScrollView{

                        VStack{
                            
                            
                            HStack{
                                
                                HStack{
  
                                    
                                    Text(currentMovie["title"]!)
                                        
                                        .font(.system(size: 30).bold())
                                        
                                        .foregroundColor(.pink)
                                      

                                    
                                        
                                    Text(currentMovie["year"]!)
                                        .font(.system(size: 17).bold())
                                        .foregroundColor(.secondary)
                                    
                                    Text(updater)

                                                            
                                }
                                .padding(.init(top: 20, leading: 0, bottom: 0, trailing: 0))
                                
                                Spacer()
                                
                            }
                            .padding(.horizontal, 100)
                            
                            
                            HStack{
                                
                                Text("IMDB Rating: ")
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                
                                Text(currentMovie["rating"]! + "/10")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Spacer()

                            }
                            .padding()
                            .padding(.horizontal, 85)

                            
                            
                            Divider()
                                .padding()
                            
                            
                            
                            HStack{
                                
                                Text("Description:")
                                    .font(.headline)
                                    .padding()
                                    .padding(.horizontal, 90)
                                
                                Spacer()
                            }
                            
                            Text(currentMovie["desc"]!)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 130)

                            
                        }   //Vstack For text
                    
                    Spacer()    //Pushes Descp/Pic up

                } //Scroll View
                    
            }//VStack for Pics/Text
           
            
            
            VStack{
                
                Spacer()
                
                HStack{
                    
                    ZStack{
                        
                        Button(action: {
                        }) {
                                Image(systemName: "xmark.circle")
                                    .foregroundColor(.white)
                                    .font(.system(size: 70))
                                    .padding(.horizontal, 50)
                                    .padding(.bottom, 20)
                                    .shadow(color: .blue, radius: 5, x: 0, y: 3)


                                }
                        
                        //Main Button Pressed
                        Button(action: {
                            
                            userStore.addToMoviesDisliked(index: userStore.getFireStoreUserIndex(uid: (Auth.auth().currentUser?.uid) ?? ""), title: currentMovie["title"]!)
                            

                                currentMovie = getCurrentMovie()
                                updater =  ""
                                updater =  " "
                            


                        }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                                    .font(.system(size: 70))
                                    .padding(.horizontal, 50)
                                    .padding(.bottom, 20)
                                    
                                }
             
                    }   //ZStack
                    
                    
                    ZStack{
                        
                        Button(action: {}) {
                                Image(systemName: "heart.circle")
                                    .foregroundColor(.white)
                                    .font(.system(size: 70))
                                    .padding(.horizontal, 50)
                                    .padding(.bottom, 20)
                                    .shadow(color: .pink, radius: 5, x: 0, y: 3)

                                    
                                }
                        
                        //Main Button Pressed
                        Button(action: {
                            
                            userStore.addToMoviesLiked(index: userStore.getFireStoreUserIndex(uid: (Auth.auth().currentUser?.uid) ?? ""), title: currentMovie["title"]!)
                            
                            
                            currentMovie = getCurrentMovie()
                            updater =  ""
                            updater =  " "

                                

                        }) {
                                Image(systemName: "heart.circle.fill")
                                    .foregroundColor(.pink)
                                    .font(.system(size: 70))
                                    .padding(.horizontal, 50)
                                    .padding(.bottom, 20)


                                }
                    }//ZStack
                    
                    
                }//Hs stack
            
            }//VStack for like buttons
            
            .sheet(isPresented: $showingSheet) {
                WelcomeSheetView()
            }
           
        } //ZStack
        .background(Image("whitePinkGradient"))
        
        .onAppear() {
            self.movieList.fetchData()
          
        }
        
       
    }
   
}





//
//struct MovieView_Preview: PreviewProvider  {
//
//    static var previews: some View {
//
//        MovieView()
//
//    }
//}

