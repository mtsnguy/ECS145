# project start
#x: A numeric vector to be graphed. ex. (3,5,2)
#estMethod: Either 'hist' or 'density'.
#tuning: The intial value of either breaks or bw.
#twoAtATime: If TRUE, always display the current graph superimposed on the previous one, to aid comparison.
s <- list(name = "Joe", salary = 5000, union = T)
class(s) <- "densEst"

print.densEst <- function(x){
  cat(x$name,"\n")
  cat("salary",x$salary,"\n")
  cat("union member",x$union,"\n")
}
s

choicefour <- T
choicetune <- T
choicepspe <- T
gmemory <- 1

exploreShape <- function(x,estMethod,tuning,twoAtATime){
  if(estMethod == 'hist'){
    if(twoAtATime){
      if(tuning == ''){
        plot(hist(Nile))
        lines(hist(Nile,breaks=gmemory),col = "red")
      }else{
        plot(hist(Nile,breaks=tuning))
        lines(hist(Nile,breaks=gmemory),col = "red")
        gmemory = tuning
      }
    }else{
      if(tuning == ''){
        plot(hist(Nile))
      }else{
        plot(hist(Nile,breaks=tuning))
        gmemory = tuning
      }
    }
  }else if(estMethod == 'density'){
    if(twoAtATime){
      if(tuning == ''){
        plot(density(Nile))
        lines(density(Nile,bw=gmemory),col = "red")
      }else{
        plot(density(Nile,bw=tuning))
        lines(density(Nile,bw=gmemory),col = "red")
        gmemory = tuning
      }
    }else{
      plot(density(Nile,bw=tuning))
      gmemory = tuning
    }
  }else{
    print('Error: Was not given a valid Method name.')
    return(0)
  }
}

print("Welcome to the Term Project.")
while(1){
  #code will repeatedly loop here to get user input for 4 choices

  #estMethod<-readline(prompt="Enter hist or density")
  #tuning<-readline(prompt="Enter your initial tuning parameter.")
  #twoAtATime<-readline(prompt="Superimpose graphs onto previous ones? (T or F)")
  #exploreShape(Nile,estMethod,tuning,twoAtATime)
  while(choicefour){
    exploreShape(Nile,'hist','',F) #testing purpose
    #exploreShape(Nile,estMethod,tuning,twoAtATime)
    print("Please select one of the four options.")
    print("1. Give a new value of the tuning parameter.")
    print("2 Zoom in/out.")
    print("3. Run an animation of tuning parameters.")
    print("4. Quit.")
    selectOption <- readline(prompt="Enter a number and press Enter: ")
    if(selectOption == 1){
      tuning <- readline(prompt = "Enter a new value of the tuning parameter:")
    }else if(selectOption == 2){
      zoom <- readline(prompt = "Zoom in or Zoom out? ('in' , 'out'):")
      #redo the graph over a narrower range of values of x
      #zoom in = reduce the size of x. zoom out = return original value of x
    }else if(selectOption == 3){
      
    }else if(selectOption == 4){
      print("Quit")
      break
    }
    break
  }
  break
  #after user selects 'Quit'. Get user's tuning parameters
  #save user selected parameters in memory and then
  while(choicetune){
    
  }
  #loop again so user can select print,summary or plot or exit
  #end program or start again
  while(choicepspe){
    
  }
}
