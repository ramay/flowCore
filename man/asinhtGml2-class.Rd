\name{asinhtGml2-class}
\docType{class}
\alias{asinhtGml2-class}
\alias{asinhtGml2}
\alias{eval,asinhtGml2,missing-method}

\title{Class asinhtGml2}
\description{Inverse hyperbolic sin transformation as parameterized in Gating-ML 2.0 is defined by the following function:
\deqn{bound(f, boundMin, boundMax) = max(min(f,boundMax),boundMin))}
where
\deqn{f(parameter, T, M, A) = (asinh(parameter * sinh(M * ln(10)) / T) +A * ln(10)) / ((M + A) * ln(10))}

This transformation is equivalent to Logicle(T, 0, M, A) (i.e., with W=0). 
It provides an inverse hyperbolic sine transformation that maps a data value onto the interval [0,1] such
that:
\itemize{ 
   \item The top of scale value (i.e., T ) is mapped to 1. 
   \item Large data values are mapped to locations similar to an (M + A)-decade logarithmic scale.
   \item A decades of negative data are brought on scale. 
} 

In addition, if a boundary is defined by the boundMin and/or boundMax parameters, then the result of this
transformation is restricted to the [boundMin,boundMax] interval. Specifically, should the result of the f
function be less than boundMin, then let the result of this transformation be boundMin. Analogically, should the 
result of the f function be more than boundMax, then let the result of this transformation be boundMax.
The boundMin parameter shall not be greater than the boundMax parameter.
}

\section{Objects from the Class}{
Objects can be created by calls to the constructor

\code{asinhtGml2(parameter, T, M, A, transformationId, boundMin, boundMax)}
}

\section{Slots}{
	 \describe{
    \item{\code{.Data}:}{Object of class \code{function} ~~ }
    \item{\code{T}:}{Object of class \code{numeric} -positive constant (top of scale value) }
    \item{\code{M}:}{Object of class \code{numeric} -positive constant (desired number of decades) }
    \item{\code{A}:}{Object of class \code{numeric} -non-negative constant that is less than or equal 
                     to M (desired number of additional negative decades) }
    \item{\code{parameters}:}{Object of class \code{"transformation"} -flow parameter to be transformed }
    \item{\code{transformationId}:}{Object of class \code{"character"} -unique ID to reference the transformation}
    \item{\code{boundMin}:}{Object of class \code{numeric} -lower bound of the transformation, default -Inf}
    \item{\code{boundMax}:}{Object of class \code{numeric} -upper bound of the transformation, default Inf}
  }
}

\section{Extends}{
Class \code{\linkS4class{singleParameterTransform}}, directly.
Class \code{\linkS4class{transform}}, by class singleParameterTransform, distance 2.
Class \code{\linkS4class{transformation}}, by class singleParameterTransform, distance 3.
Class \code{\linkS4class{characterOrTransformation}}, by class singleParameterTransform, distance 4.
}

\section{Methods}{
No methods defined with class asinhtGml2 in the signature.
}

\references{
Gating-ML 2.0: International Society for Advancement of Cytometry (ISAC) standard for 
representing gating descriptions in flow cytometry. \url{http://flowcyt.sourceforge.net/gating/20141009.pdf}
}

\author{Spidlen, J.}

\note{
The inverse hyperbolic sin transformation object can be evaluated using the eval method by passing the data frame as an argument.
The transformed parameters are returned as a matrix with a single column. (See example below)  
}

\seealso{
\code{\link{asinht}}, \code{\link{transform-class}}, \code{\link{transform}}
}

\examples{
myDataIn <- read.FCS(system.file("extdata", "0877408774.B08", 
    package="flowCore"))
myASinH1 <- asinhtGml2(parameters = "FSC-H", T = 1000, M = 4.5, 
    A = 0, transformationId="myASinH1")
transOut <- eval(myASinH1)(exprs(myDataIn))
}

\keyword{classes}
