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

#for zoom out
ogdata <- Nile

dataset <- Nile

#functions below are for the S3 object , will have functions plot,summary and print
exploreS3 <- function(x,estMethod,tuningparams,twoAtATime){
  s <- list(data=x,method=estMethod,tuning=tuningparams,two=twoAtATime)
  class(s) <- "densEst"
  return (s)
}
print.densEst <- function(x){
  cat(x$data,"\n")
}
plot.densEst <- function(x){
  for (tune in x$tuning){
    if(x$method == 'hist'){
      if(x$two){
        plot(hist(x$data,breaks=tune))
        lines(hist(x$data,breaks=gmemory),col = "red")
        gmemory = tune
      }else{
        plot(hist(x,breaks=tuning))
        gmemory = tune
      }
      readline(prompt = "Hit enter to view next Plot.")
    }else if(x$method == 'density'){
      if(x$two){
        plot(density(x$data,bw=tune))
        lines(density(x$data,bw=gmemory),col = "red")
        gmemory = tune
      }else{
        plot(density(x$data,bw=tune))
        gmemory = tune
      }
      readline(prompt = "Hit enter to view next Plot.")
    }else{
      cat('Error: Was not given a valid Method name.\n')
      break
    }
  }
}
test <- exploreS3(ogdata,'hist',gu,T)
plot(test)

exploreShape <- function(x,estMethod,tuning,twoAtATime){
  if(estMethod == 'hist'){
    if(twoAtATime){
      if(tuning == ''){
        plot(hist(x))
        lines(hist(x,breaks=gmemory),col = "red")
      }else{
        plot(hist(x,breaks=tuning))
        lines(hist(x,breaks=gmemory),col = "red")
        gmemory = tuning
      }
    }else{
      if(tuning == ''){
        plot(hist(x))
      }else{
        plot(hist(x,breaks=tuning))
        gmemory = tuning
      }
    }
  }else if(estMethod == 'density'){
    if(twoAtATime){
      if(tuning == ''){
        plot(density(x))
        lines(density(x,bw=gmemory),col = "red")
      }else{
        plot(density(x,bw=tuning))
        lines(density(x,bw=gmemory),col = "red")
        gmemory = tuning
      }
    }else{
      plot(density(x,bw=tuning))
      gmemory = tuning
    }
  }else{
    cat('Error: Was not given a valid Method name.\n')
    return(0)
  }
}

uservector <- function(){
  x <- 0
  myvec = vector()
  while(x<5){
    n <- readline(prompt = "Input a tuning parameter(type 'quit' to end): ")
    if(n != 'quit'){
      myvec = c(myvec,n)
      x<- x+1
    }else{
      return (as.integer(myvec))
    }
  }
  return (as.integer(myvec))
}
animate <- function(x,estMethod){
  ki <- 1
  cat("Running animation...")
  while(1){
    if(estMethod == 'hist'){
      hist(x,breaks=ki)
    }else if(estMethod == 'density'){
      plot(density(x,bw=ki))
    }
    ki <- ki + 2
    Sys.sleep(0.1)
    if(ki >= 100){
      break
    }
  }
}
cat("Welcome to the Term Project.\n")
while(1){
  #code will repeatedly loop here to get user input for 4 choices
  estMethod<-readline(prompt="Enter hist or density: ")
  #print the default values for bw and break
  tuning<-as.integer(readline(prompt="Enter your initial tuning parameter: "))
  twot<-readline(prompt="Superimpose graphs onto previous ones? (T or F): ")
  #exploreShape(Nile,estMethod,tuning,twoAtATime)
  while(choicefour){
    #exploreShape(Nile,'hist','',F) #testing purpose
    exploreShape(dataset,estMethod,tuning,twot)
    cat("Please select one of the four options.\n")
    cat("1. Give a new value of the tuning parameter.\n")
    cat("2. Zoom in/out.\n")
    cat("3. Run an animation of tuning parameters.\n")
    cat("4. Quit.\n")
    selectOption <- readline(prompt="Enter a number and press Enter: ")
    if(selectOption == 1){
      tuning <- as.integer(readline(prompt = "Enter a new value of the tuning parameter:"))
    }else if(selectOption == 2){
      zoom <- readline(prompt = "Zoom in or Zoom out? ('in' , 'out'):")
      if(zoom == 'in'){
        zoomparam <- 10
        if(length(dataset) < zoomparam){
          cat("You can't zoom in anymore.\n")
        }else{
          cat("Zooming in...\n")
          dataset = dataset[zoomparam:(length(dataset)-zoomparam)]
        }
      }else if(zoom == 'out'){
        cat("Zooming out...\n")
        dataset = ogdata
      }
    }else if(selectOption == 3){
      #animation
      animate(dataset,estMethod)
    }else if(selectOption == 4){
      cat("Quit\n")
      break
    }
  }
  #after user selects 'Quit'. Get user's tuning parameters
  #save user selected parameters in memory and then
  #returns a vector of integers
  cat('Save some of your tuning parameters!(5 max)\n')
  userparam = uservector()
  
  #Create the s3 object that we'll use in the next part
  s3obj <- exploreS3(ogdata,estMethod,userparam,twot)
  
  #loop again so user can select cat,summary or plot or exit
  #give option to end program or start again
  while(choicepspe){
    break
  }
  break
}

