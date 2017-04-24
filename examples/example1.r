#library(rflowcyt)
library(graph)
library(prada)


Sweave("inst/doc/filtering-flowCore.Rnw")
Sweave("inst/doc/HowTo-flowCore.Rnw")

## if the package is built, you can start from here
library(flowCore)
## create the data to be used
## these are three interesting wells from a BD FACS CAP(TM) plate
## with PBMS (perpheral blood monocytes) on the plate
b08 = read.FCS("inst/extdata/0877408774.B08",transformation="scale")
e07 = read.FCS("inst/extdata/0877408774.E07",transformation="scale")
f06 = read.FCS("inst/extdata/0877408774.F06",transformation="scale")
class(b08)
#[1] "flowFrame"
dim(b08@exprs)
#[1] 10000     8
dimnames(b08@exprs)[[2]]
#  $P1N    $P2N    $P3N    $P4N    $P5N    $P6N    $P7N    $P8N 
#"FSC-H" "SSC-H" "FL1-H" "FL2-H" "FL3-H" "FL1-A" "FL4-H"  "Time" 

## the fluorescence readings where converted to a relative range at the time of import
range(b08@exprs[,"FL1-H"])
#[1] 0.0000000 0.8914956
range(b08@exprs[,"FL2-H"])
#[1][1] 0 1

## these are the transformed values
flowPlot(b08,plotParameters=c("FSC-H","SSC-H"),main="B08")
flowPlot(b08,plotParameters=c("FL1-H","FL2-H"),main="B08")
flowPlot(b08,plotParameters=c("FSC-H","FL1-H"),main="B08")
flowPlot(e07,plotParameters=c("FSC-H","SSC-H",main="E07"))
flowPlot(f06,plotParameters=c("FSC-H","SSC-H"),main="F06")
flowPlot(f06,plotParameters=c("FL1-H","FL2-H"),main="F06")


## the first gate is a rectangleGate to filter out debris
filter1 = rectangleGate("FSC-H"=c(.2,.8),"SSC-H"=c(0,.8))
b08.result1 = filter(b08,filter1)
summary(b08.result1)
#rectangleGate: 8291 of 10000 (82.91%)
sum(b08 %in% filter1)
#[1] 8291
flowPlot(b08,y=b08.result1,main="B08 - Nondebris")
## 
e07.result1 = filter(e07,filter1)
summary(e07.result1)
#rectangleGate: 8514 of 10000 (85.14%)
sum(e07.result1@subSet)
#[1] 8514
flowPlot(e07,y=e07.result1,main="E07 - Nondebris")
##
f06.result1 = filter(f06,filter1)
flowPlot(f06,y=f06.result1,main="F06 - Nondebris")
summary(f06.result1)
#rectangleGate: 8765 of 10000 (87.65%)
sum(f06.result1@subSet)
#[1] 8765


## the second gate gets the live cells (lymphocytes)
filter2 = norm2Filter("FSC-H","SSC-H",scale.factor=2,method="covMcd",filterId="Live Cells")
b08.result2 = filter(b08,filter2 %subset% b08.result1)
flowPlot(b08,y=b08.result2,parent=b08.result1)
summary(b08.result2)
#Live Cells in rectangleGate: 6496 of 10000 (64.96%)
summary(b08.result2 %subset% b08.result1)
#Live Cells in rectangleGate in rectangleGate: 6496 of 8291 (78.35%)
##
e07.result2 = filter(e07,filter2 %subset% e07.result1)
flowPlot(e07,y=e07.result2,parent=e07.result1)
sum(e07.result2@subSet)
#[1] 6416
f06.result2 = filter(f06,filter2 %subset% f06.result1)
flowPlot(f06,y=f06.result2,parent=f06.result1)
sum(f06.result2@subSet)
#[1] 6959

## the third-fifth gates get the positive cells for the marker in FL1-H
## this is a really interesting example because it illustrates that there
## are two subpopulations. Naturally we would like to automatically find them
## In this case we want to now what percent the positive population in FL1-H is of the
## total population
flowPlot(b08,parent=b08.result2,plotParameters=c("FSC-H","FL1-H"))
## filter 3 is a range gate for the positive cells
filter3 = rectangleGate("FL1-H"=c(.4,Inf),filterId="FL1-H+")
b08.result3 = filter(b08,filter3 %subset% b08.result2)
flowPlot(b08,y=b08.result3,parent=b08.result2,plotParameters=c("FSC-H","FL1-H"))
sum(b08.result3@subSet)
#[1] 3559
summary(b08.result3 %subset% b08.result2)
#FL1-H+ in Live Cells in rectangleGate in Live Cells in rectangleGate: 3559 of 6496 (54.79%)
sum(b08.result3@subSet)/sum(b08.result2@subSet)
#[1] 0.54787

## filter4 is an norm2Fit filter on the positive cells
filter4=norm2Filter("FSC-H","FL1-H",filterId="FL1-H+",scale.factor=2,method="covMcd")
b08.result4 = filter(b08,filter4 %subset% b08.result2)
flowPlot(b08,y=b08.result4,parent=b08.result2,plotParameters=c("FSC-H","FL1-H"))
summary(b08.result4)
#FL1-H+ in Live Cells in rectangleGate: 3490 of 10000 (34.90%)
summary(b08.result4 %subset% b08.result2)
#FL1-H+ in Live Cells in rectangleGate in Live Cells in rectangleGate: 3490 of 6496 (53.73%)


###############################################
## the next filter requires a NOT gate
## result5 is a norm2Fit filter on the negative cells
b08.result5 = filter(b08,filter4 %subset% (b08.result2 & !b08.result4))
flowPlot(b08,y=b08.result5,parent=b08.result2,plotParameters=c("FSC-H","FL1-H"))
## the cells in the filter as a subset of the current cells
summary(b08.result5 %subset% b08.result2)
#FL1-H+ in Live Cells in rectangleGate and not FL1-H+ in Live Cells in rectangleGate in Live Cells in rectangleGate: 2572 of 6496 (39.59%)
## the cells in the filter as a subset of all cells
summary(b08.result5)
#FL1-H+ in Live Cells in rectangleGate and not FL1-H+ in Live Cells in rectangleGate: 2572 of 10000 (25.72%)
## the cells in the filter as a subset of the negative cells (not in the positive range gate)
summary(b08.result5 %subset% (b08.result2 & !b08.result4))
#FL1-H+ in ...  rectangleGate and not FL1-H+ in Live Cells in rectangleGate: 2572 of 3006 (85.56%)
sum(b08.result4@subSet)/(sum(b08.result4@subSet)+sum(b08.result5@subSet))
#[1] 0.5757176
## the cells in the negative norm2Fit as a percent of the cells in both norm2Fit gates
summary(b08.result4 %subset% (b08.result4 | b08.result5))
#FL1-H+ in Live Cells in rectangleGate ... e and not FL1-H+ in Live Cells in rectangleGate: 3490 of 6062 (57.57%)

## the sixth-eighth gates get the positive cells for the marker in FL2-H
## in this case there is only a negative population
flowPlot(b08,parent=b08.result2,plotParameters=c("FSC-H","FL2-H"))
filter6 = rectangleGate("FL2-H"=c(.4,Inf),filterId="FL2-H+")
b08.result6 = filter(b08,filter6 %subset% b08.result2)
flowPlot(b08,y=b08.result6,parent=b08.result2,plotParameters=c("FSC-H","FL2-H"))
summary(b08.result6 %subset% b08.result2)
#FL2-H+ in Live Cells in rectangleGate in Live Cells in rectangleGate: 301 of 6496 (4.63%)
filter7=norm2Filter("FSC-H","FL2-H",filterId="FL2-H-",scale.factor=2,method="covMcd")
b08.result7 = filter(b08,filter7 %subset% b08.result2)
flowPlot(b08,y=b08.result7,parent=b08.result2,plotParameters=c("FSC-H","FL2-H"))
summary(b08.result7 %subset% b08.result2)
#FL2-H- in Live Cells in rectangleGate in Live Cells in rectangleGate: 5432 of 6496 (83.62%)

## where do the cells with 0 fluorescence in FL2-H?
filter8 = rectangleGate("FL2-H"=c(-Inf,0.01),filterId="No Signal in FL2")
b08.result8 = filter(b08,filter8 %subset% b08.result2)
flowPlot(b08,y=b08.result8,parent=b08.result2,plotParameters=c("FSC-H","FL2-H"))
flowPlot(b08,y=b08.result8,parent=b08.result2,plotParameters=c("FSC-H","SSC-H"))
flowPlot(b08,y=b08.result8,plotParameters=c("FSC-H","SSC-H"))
flowPlot(b08,y=b08.result8,parent=b08.result2,plotParameters=c("FL1-H","FL2-H"))



## the ninth-eleventh gates get the positive cells for the marker in FL3-H
## again, there is only a negativ3e population here
plot(b08,parent=b08.result2@subSet,plotParameters=c("FSC-H","FL3-H"),ylim=c(0,1024),xlim=c(0,1024))
filter9 = new("rectangleGate",filterId="FL3-H+",parameters="FL3-H",min=500,max=Inf)
b08.result9 = applyFilter(filter9,b08,b08.result2@subSet)
plot(b08,y=b08.result9,parent=b08.result2@subSet,plotParameters=c("FSC-H","FL3-H"),
          xlim=c(0,1024),ylim=c(0,1024))
sum(b08.result9@subSet)
#[1] 0
sum(b08.result9@subSet)/sum(b08.result2@subSet)
#[1] 0
filter10=new("norm2Filter",filterId="FL3-H-",scale.factor=2,method="covMcd",parameters=c("FSC-H","FL3-H"))
b08.result10 = applyFilter(filter10,b08,b08.result2@subSet)
plot(b08,y=b08.result10,parent=b08.result2@subSet,plotParameters=c("FSC-H","FL3-H"),
          xlim=c(0,1024),ylim=c(0,1024))
sum(b08.result10@subSet)
#[1] 5834

## this doesn't produce a sensible result since there is no positive population remaining
b08.result11 = applyFilter(filter10,b08,b08.result2@subSet-b08.result10@subSet)
plot(b08,y=b08.result11,parent=b08.result2@subSet,plotParameters=c("FSC-H","FL3-H"),
          xlim=c(0,1024),ylim=c(0,1024))
sum(b08.result11@subSet)
#[1] 
sum(b08.result11@subSet)/(sum(b08.result11@subSet)+sum(b08.result10@subSet))
#[1] 


