# project start
#x: A numeric vector to be graphed. ex. (3,5,2)
#estMethod: Either 'hist' or 'density'.
#tuning: The intial value of either breaks or bw.
#twoAtATime: If TRUE, always display the current graph superimposed on the previous one, to aid comparison.
choicefour <- T
choicetune <- T
choicepspe <- T
gmemory <- -1

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
  cat("Method:", x$method,"\n")
  cat("Tuning parameters:", x$tuning,"\n")
  cat("Superimpose plots:", x$two,"\n")
}
summary.densEst <- function(x){
  summary(x$data)
}
plot.densEst <- function(x){
  for (tune in x$tuning){
    if(x$method == 'hist'){
      if(x$two){
        p1 <- hist(x$data,breaks=tune,plot=FALSE)
        plot(p1, col="blue", angle = 135,density=10, main="Histogram")
        if (gmemory >= 0) {
          p2 <- hist(x$data,breaks=gmemory,plot=FALSE)
          plot(p2, col="red", add=T, angle = 45,density=10)
        }
        gmemory <<- tune
      }else{
        plot(hist(x,breaks=tuning), main="Histogram")
        gmemory <<- tune
      }
      readline(prompt = "Hit enter to view next Plot.")
    }else if(x$method == 'density'){
      if(x$two){
        plot(density(x$data,bw=tune), main="Density")
        if (gmemory >= 0) {
          lines(density(x$data,bw=gmemory),col = "red")
        }
        gmemory <<- tune
      }else{
        plot(density(x$data,bw=tune), main="Density")
        gmemory <<- tune
      }
      readline(prompt = "Hit enter to view next Plot.")
    }else{
      cat('Error: Was not given a valid Method name.\n')
      break
    }
  }
}

uservector <- function(){
  x <- 0
  myvec = vector()
  while(1){
    n <- readline(prompt = "Input a tuning parameter(type 'quit' to end): ")
    if(grepl("^[0-9]+$",n) | n == "quit") {
      if(n != 'quit'){
        myvec = c(myvec,n)
        x<- x+1
      }else{
        return (as.integer(myvec))
      }
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

newShape <- function(x,estMethod,tuning,twoAtATime){
  if(estMethod == 'hist'){
    if(twoAtATime){
      if(tuning == ''){
        p1 <- hist(x,plot=FALSE)
        plot(p1, col="blue", angle = 135,density=10, main="Histogram")
        if (gmemory >= 0) {
          p2 <- hist(x,breaks=gmemory,plot=FALSE)
          plot(p2, col="red", add=T, angle = 45, density=10)
        }
      }else{
        p1 <- hist(x,breaks=tuning,plot=FALSE)
        plot(p1, col="blue", angle = 135,density=10, main="Histogram")
        if (gmemory >= 0) {
          p2 <- hist(x,breaks=gmemory,plot=FALSE)
          plot(p2, add=T, col="red", angle=45,density=10)
        }
        gmemory <<- tuning
      }
    }else{
      if(tuning == ''){
        p1 <- hist(x,breaks=tuning,plot=FALSE)
        plot(p1, col="blue", angle = 135,density=10, main="Histogram")
      }else{
        p1 <- hist(x,breaks=tuning,plot=FALSE)
        plot(p1, col="blue", angle = 135,density=10, main="Histogram")
        gmemory <<- tuning
      }
    }
  }else if(estMethod == 'density'){
    if(twoAtATime){
      if(tuning == ''){
        plot(density(x), main="Density")
        if (gmemory >= 0) {
          lines(density(x,bw=gmemory),col = "red")
        }
      }else{
        plot(density(x,bw=tuning), main="Density")
        if (gmemory >= 0) {
          lines(density(x,bw=gmemory),col = "red")
        }
        gmemory <<- tuning
      }
    }else{
      plot(density(x,bw=tuning), main="Density")
      gmemory <<- tuning
    }
  }else{
    cat('Error: Was not given a valid Method name.\n')
    return(0)
  }
}

exploreShape <- function(x,estMethod,tuning,twoAtATime){
  dataset <<- sort(x, decreasing=FALSE)
  ogdata <<- sort(x, decreasing=FALSE)
  while(choicefour){
    newShape(dataset,estMethod,tuning,twoAtATime)
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
          dataset <<- dataset[zoomparam:(length(dataset)-zoomparam)]
        }
      }else if(zoom == 'out'){
        cat("Zooming out...\n")
        dataset <<- ogdata
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
  cat('Save some of your tuning parameters!\n')
  userparam = uservector()
  
  #Create the s3 object that we'll use in the next part
  s3obj <- exploreS3(ogdata,estMethod,userparam,twoAtATime) 
  return(s3obj)
}