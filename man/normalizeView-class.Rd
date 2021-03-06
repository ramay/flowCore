\name{normalizeView-class}

\docType{class}

\alias{normalizeView-class}
\alias{normalizeView}
\alias{Rm,normalizeView,workFlow,character-method}

\title{Class "normalizeView"}

\description{

  Class and method to capture the result of normalization operations in a
  flow cytometry workflow.

}

\section{Objects from the Class}{

  Objects should be created using the \code{add} method, which creates a
  \code{normalizeView} from a \code{\link{normalization}} object and
  directly assigns it to a \code{\link{workFlow}}. Alternatively, one
  can use the \code{normalizeView} constructor function for more programmatic
  access.  }

\section{Slots}{
  
  \describe{

    \item{\code{ID}:}{Object of class \code{"character"}. A unique
      identifier for the view. }
    
    \item{\code{name}:}{Object of class \code{"character"}. A more
      human-readable name}
    
    \item{\code{action}:}{Object of class \code{"fcActionReference"}. A
      reference to the
      \code{\link[flowCore:actionItem-class]{actionItem}} that generated
      the view. }

    \item{\code{env}:}{Object of class \code{"environment"}. The
      evaluation environment in the \code{\link{workFlow}}. }
    
    \item{\code{data}:}{Object of class \code{"fcDataReference"} A
      reference to the data that is associated to the view.}
    
  }
}

\section{Extends}{
  
  Class \code{"\linkS4class{view}"}, directly.
  
}


\usage{

normalizeView(workflow, ID=paste("normViewRef", guid(), sep="_"),
                          name="default", action, data)

}

\arguments{

  \item{workflow}{ An object of class \code{\link{workFlow}} for which a
    view is to be created. }

  \item{ID}{ A unique identifier of the view, most likely created by
    using the internal \code{guid} function. }

  \item{name}{ A more human-readable name of the view. }
  
  \item{data, action}{ References to the data and
    \code{\link[flowCore:actionItem-class]{actionItem}} objects, respectively. }
  
}

\value{

  A reference to the \code{normalizeView} that is created inside the
  \code{\link{workFlow}} environment as a side effect of calling the
  \code{add} method.

  A \code{normalizeView} object for the constructor.
  
}


\section{Methods}{
  
  \describe{
    
    \item{Rm}{\code{signature(symbol = "normalizeView", envir =
	"workFlow", subSymbol = "character")}: Remove a
      \code{normalizeView} from a \code{\link{workFlow}}. This method is
      recursive and will also remove all dependent \code{views} and
      \code{\link[flowCore:actionItem-class]{actionItem}}s. }
    
  }
}


\author{ Florian Hahne }

\seealso{
	
  \code{\linkS4class{workFlow}},
  \code{\linkS4class{view}},
  \code{\linkS4class{gateView}},
  \code{\linkS4class{transformView}},
  \code{\linkS4class{compensateView}},
  \code{\linkS4class{actionItem}}
  
}

\examples{
showClass("view")
}

\keyword{classes}
