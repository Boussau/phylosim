##	
## Copyright 2009 Botond Sipos	
## See the package description for licensing information.	
##	
##########################################################################/** 
#
# @RdocClass Event
# 
# @title "The Event class"
# 
# \description{ 
#	
#	This is the class representing an event. Event objects usually are generated by the \code{getEventsAtSite.*}
#	methods based on the state of attached Site object and the properties of the generating Process object.
#
#	The Perform method will refuse to modify target objects if the position field is not set. The Perform method can 
#	be called only once for any Event object.
#	
#	@classhierarchy
# }
#	
# @synopsis
#	
# \arguments{
# 	\item{name}{The name of the Event object. Often stores useful information.}
# 	\item{rate}{The rate of the event.}
# 	\item{site}{The associated Site object.}
# 	\item{position}{The position of associated Site object in the enclosing Sequence object (if any).}
#	\item{process}{The generator Process object.}
#	\item{handler}{The handler function for the Event object. It will be called by \code{Perform.Event} with the Event object as an argument to make the changes corresponding to the event.}
# 	\item{...}{Not used.}
#	}
# 
# \section{Fields and Methods}{ 
# 	@allmethods
# }
# 
# \examples{ 
#	# Note: the following examples are not very useful
#	# unless you want to implement your own process.
#
#	# create a Sequence object and a Process object
#	seq<-NucleotideSequence(string="A");
#	p<-Process(alphabet=NucleotideAlphabet())
#	# get the Site object from the Sequence object
#	s<-seq$sites[[1]]
#	# attach p to s
#	attachProcess(s,p)
#	# create an Event object
#	e<-Event(name="A->G",rate=0.1,site=s,process=p,position=1)
#	# get object summary
#	summary(e)
#	# get event name
#	e$name
#	# set/get event rate
#	e$rate<-0.2
#	e$rate
#	# get site
#	e$site
#	# set/get event handler
#	e$.handler<-function(this){this$.site$state<-"G"}
#	e$handler
#	# perform the event
#	Perform(e)
#	# check the state of the target site
#	s$state
# }
# 
# @author
#
# \seealso{ 
# 	Site Process Sequence getEventsAtSite.GeneralSubstitution
# }
# 
#*/###########################################################################
setConstructorS3(
	"Event",
	function( 
		name=NA,
		rate=NA,
		site=NA,
		position=NA,
		process=NA,
		handler=NA,
		... 
		){

		this<-extend(
			PSRoot(),
			"Event",
			.name="Anonymous",
			.rate=NA,
			.process=NA,
			.handler=NA,
			.site=NA,
			.position=NA,
			.write.protected=FALSE,
			.is.event=TRUE
		);

		STATIC<-TRUE;
						
		if(!missing(name)) {
			this$name<-name;
			STATIC<-FALSE;
		}
		
		if(!missing(rate)) {
			this$rate<-rate;
			STATIC<-FALSE;
		}	

		if(!missing(process)) {
			this$process<-process;
			STATIC<-FALSE;
		}	
		
		if(!missing(site)) {
			this$site<-site;
			STATIC<-FALSE;
		}	
		
		if(!missing(position)) {
			this$position<-position;
			STATIC<-FALSE;
		}	
		
		# The site object was passed through a getField method,
		# which disabled the virtual fields, so we have to enable them:
		if (!is.na(this$.site)){
				this$.site<-enableVirtual(this$.site);
		}
		this;
	},
	enforceRCC=TRUE
);

##
## Method: is.Event
##
###########################################################################/**
#
# @RdocDefault is.Event
# 
# @title "Check whether an object inherits from the class Event" 
# 
# \description{ 
#	@get "title".
# } 
# 
# @synopsis 
# 
# \arguments{ 
# 	\item{this}{An object.} 
# 	\item{...}{Not used.} 
# } 
# 
# \value{ 
# 	TRUE or FALSE.
# } 
# 
# \examples{
#	# create some objects
#	e<-Event(); a<-Alphabet()
#	# check if they inherit from Event
#	is.Event(e)
#	is.Event(a)
# } 
# 
# @author 
# 
# \seealso{ 
# 	@seeclass 
# } 
# 
#*/###########################################################################
setMethodS3(
  "is.Event",
  class="default",
  function(
    this,
    ...
  ){

    if(!is.PSRoot(this)) {return(FALSE)}
   	if(!is.null(this$.is.event)){return(TRUE)}
    if ( inherits(this, "Event")) {
      this$.is.event<-TRUE;
      return(TRUE);
    } else {
      return(FALSE)
    }

  },
  private=FALSE,
  protected=FALSE,
  overwrite=FALSE,
  conflict="warning",
  validators=getOption("R.methodsS3:validators:setMethodS3")
);

##	
## Method: getName
##	
###########################################################################/**
#
# @RdocMethod getName
# 
# @title "Get the name of an Event object" 
# 
# \description{ 
#	@get "title".
# } 
# 
# @synopsis 
# 
# \arguments{ 
# 	\item{this}{An event object.} 
# 	\item{...}{Not used.} 
# } 
# 
# \value{ 
# 	A character vector of length one.
# } 
# 
# \examples{
#	# create an Event object
#	e<-Event(name="MyEvent")
#	# get event name 
#	getName(e)
#	# get name via virtual field
#	e$name
# } 
# 
# @author 
# 
# \seealso{ 
# 	@seeclass 
# } 
# 
#*/###########################################################################
setMethodS3(
	"getName", 
	class="Event", 
	function(
		this,
		...
	){
		
		this$.name;

	},
	private=FALSE,
	protected=FALSE,
	overwrite=FALSE,
	conflict="warning",
	validators=getOption("R.methodsS3:validators:setMethodS3")
);

##	
## Method: setName
##	
###########################################################################/**
#
# @RdocMethod setName
# 
# @title "Set the name of an Event object" 
# 
# \description{ 
#	@get "title".
# } 
# 
# @synopsis 
# 
# \arguments{ 
# 	\item{this}{An Event object.} 
# 	\item{new.name}{A character vector of length one.} 
# 	\item{...}{Not used.} 
# } 
# 
# \value{ 
# 	The new name (invisible).
# } 
# 
# \examples{
#	# create an Event object
#	e<-Event()
#	# set event name
#	setName(e,"Insertion")
#	# get event name
#	e$name
#	# set name via virtual field
#	e$name<-"Deletion"
#	e$name
# } 
# 
# @author 
# 
# \seealso{ 
# 	@seeclass 
# } 
# 
#*/###########################################################################
setMethodS3(
	"setName", 
	class="Event", 
	function(
		this,
		new.name,
		...
	){
		.checkWriteProtection(this);	
		if(!exists(x="PSIM_FAST")){
		
		if(missing(new.name)){throw("No new name provided!\n")}
		new.name<-as.character(new.name);	
		if (new.name == "") {throw("Cannot set empty name!\n")}
		
		}
		this$.name<-new.name;
		
	},
	private=FALSE,
	protected=FALSE,
	overwrite=FALSE,
	conflict="warning",
	validators=getOption("R.methodsS3:validators:setMethodS3")
);

##	
## Method: getRate
##	
###########################################################################/**
#
# @RdocMethod getRate
# 
# @title "Get the rate of an Event object" 
# 
# \description{ 
#	@get "title".
# } 
# 
# @synopsis 
# 
# \arguments{ 
# 	\item{this}{An Event object.} 
# 	\item{...}{Not used.} 
# } 
# 
# \value{ 
# 	A numeric vector of length one.
# } 
# 
# \examples{
#	# create an Event object
#	e<-Event(rate=0.1)
#	# get rate
#	getRate(e)
#	# get rate via virtual field
#	e$rate
# } 
# 
# @author 
# 
# \seealso{ 
# 	@seeclass 
# } 
# 
#*/###########################################################################
setMethodS3(
	"getRate", 
	class="Event", 
	function(
		this,
		...
	){
		
		this$.rate;

	},
	private=FALSE,
	protected=FALSE,
	overwrite=FALSE,
	conflict="warning",
	validators=getOption("R.methodsS3:validators:setMethodS3")
);

##	
## Method: setRate
##	
###########################################################################/**
#
# @RdocMethod setRate
# 
# @title "Set the rate of an Event object" 
# 
# \description{ 
#	@get "title".
# } 
# 
# @synopsis 
# 
# \arguments{ 
# 	\item{this}{An Event object.} 
# 	\item{value}{The event rate.} 
# 	\item{...}{Not used.} 
# } 
# 
# \value{ 
# 	The new value of the rate (invisible).
# } 
# 
# \examples{
#	# create an Event object
#	e<-Event(rate=0.1)
#	# set  a new rate
#	setRate(e,0.2)
#	# get rate via virtual field
#	e$rate
#	# set rate via virtual field
#	e$rate<-0.5
#	e$rate
# } 
# 
# @author 
# 
# \seealso{ 
# 	@seeclass 
# } 
# 
#*/###########################################################################
setMethodS3(
	"setRate", 
	class="Event", 
	function(
		this,
		value,
		...
	){
	
		.checkWriteProtection(this);	
		if(!exists(x="PSIM_FAST")){
		
		if(missing(value)){throw("No new rate provided!\n")}
		else if (!is.numeric(value)){throw("The rate must be numeric!\n")}
		
		}
		this$.rate<-value;
		
	},
	private=FALSE,
	protected=FALSE,
	overwrite=FALSE,
	conflict="warning",
	validators=getOption("R.methodsS3:validators:setMethodS3")
);

##	
## Method: getProcess
##	
###########################################################################/**
#
# @RdocMethod getProcess
# 
# @title "Get the Process object which generated an Event object" 
# 
# \description{ 
#	@get "title".
# } 
# 
# @synopsis 
# 
# \arguments{ 
# 	\item{this}{An Event object.} 
# 	\item{...}{Not used.} 
# } 
# 
# \value{ 
# 	A Process object.
# } 
# 
# \examples{
#	# create a sequence and attach a process
#	s<-NucleotideSequence(string="ATGC",processes=list(list(JC69())))
#	# get the first active event from the first site
#	e<-s$sites[[1]]$events[[1]]
#	# get the generator process for e
#	e$process
# } 
# 
# @author 
# 
# \seealso{ 
# 	@seeclass 
# } 
# 
#*/###########################################################################
setMethodS3(
	"getProcess", 
	class="Event", 
	function(
		this,
		...
	){
		
		this$.process;

	},
	private=FALSE,
	protected=FALSE,
	overwrite=FALSE,
	conflict="warning",
	validators=getOption("R.methodsS3:validators:setMethodS3")
);

##	
## Method: setProcess
##	
###########################################################################/**
#
# @RdocMethod setProcess
# 
# @title "Set the generator process for an Event object" 
# 
# \description{ 
#	@get "title".
# } 
# 
# @synopsis 
# 
# \arguments{ 
# 	\item{this}{An Event object.} 
# 	\item{new.proc}{A valid Process object.} 
# 	\item{...}{Not used.} 
# } 
# 
# \value{ 
# 	A Process object.
# } 
# 
# \examples{
#	# create an Event object
#	e<-Event()
#	# set a generator process for e
#	setProcess(e,Process())
#	# get generator process
#	e$process
#	# set process via virtual field
#	e$process<-K80()
#	e$process
# } 
# 
# @author 
# 
# \seealso{ 
# 	@seeclass 
# } 
# 
#*/###########################################################################
setMethodS3(
	"setProcess", 
	class="Event", 
	function(
		this,
		new.proc,
		...
	){
		
		.checkWriteProtection(this);	
		if(!exists(x="PSIM_FAST")){
		
		if(missing(new.proc)){throw("No new rate provided!\n")}
		else if (!is.Process(new.proc)){throw("Process object invalid!\n")}
		
		}
		this$.process<-new.proc;

	},
	private=FALSE,
	protected=FALSE,
	overwrite=FALSE,
	conflict="warning",
	validators=getOption("R.methodsS3:validators:setMethodS3")
);

##	
## Method: getHandler
##	
###########################################################################/**
#
# @RdocMethod getHandler
# 
# @title "Get the handler function of an Event object" 
# 
# \description{ 
#	@get "title".
# } 
# 
# @synopsis 
# 
# \arguments{ 
# 	\item{this}{An Event object.} 
# 	\item{...}{Not used.} 
# } 
# 
# \value{ 
# 	A function object.
# } 
# 
# \examples{
#	# create a sequence and attach a process
#	s<-NucleotideSequence(string="ATGC",processes=list(list(JC69())))
#	# get the first active event from the first site
#   # only Sequence methods set .position, 
#   # so s$sites[[1]]$events[[1]] wouldn't work.
#	e<-getEvents(s,1)[[1]]	
#	# het the handler of e
#	getHandler(e)
# } 
# 
# @author 
# 
# \seealso{ 
# 	@seeclass 
# } 
# 
#*/###########################################################################
setMethodS3(
	"getHandler", 
	class="Event", 
	function(
		this,
		...
	){
		
		this$.handler;

	},
	private=FALSE,
	protected=FALSE,
	overwrite=FALSE,
	conflict="warning",
	validators=getOption("R.methodsS3:validators:setMethodS3")
);

##	
## Method: setHandler
##	
###########################################################################/**
#
# @RdocMethod setHandler
#
# @title "Forbidden action: setting the handler function of an Event object"
#
# \description{
#       @get "title".
#	The handler function is tipically set by a \code{getEventsAtSite.*} method generating the Event object
#	by directly modifying the this$.handler field or by the \code{.setHandler()} method.
# }
#
# @synopsis
#
# \arguments{
#       \item{this}{An object.}
#       \item{value}{Not used.}
#       \item{...}{Not used.}
# }
#
# \value{
#	Throws an error.
# }
#
# @author
#
# \seealso{
#       @seeclass
# }
#
#*/###########################################################################
setMethodS3(
	"setHandler", 
	class="Event", 
	function(
		this,
		value,
		...
	){
		
		virtualAssignmentForbidden(this);
		
	},
	private=FALSE,
	protected=FALSE,
	overwrite=FALSE,
	conflict="warning",
	validators=getOption("R.methodsS3:validators:setMethodS3")
);

##	
## Method: getSite
##	
###########################################################################/**
#
# @RdocMethod getSite
# 
# @title "Get the Site object associated with an Event object" 
# 
# \description{ 
#	@get "title".
# } 
# 
# @synopsis 
# 
# \arguments{ 
# 	\item{this}{An Event object.} 
# 	\item{...}{Not used.} 
# } 
# 
# \value{ 
# 	A Site object.
# } 
# 
# \examples{
#	# create a sequence and attach a process
#	s<-NucleotideSequence(string="ATGC",processes=list(list(JC69())))
#	# get the first active event from the first site
#	e<-s$sites[[1]]$events[[1]]
#	# get the site associated with e
#	getSite(e)
#	# get site via virtual field
#	e$site
# } 
# 
# @author 
# 
# \seealso{ 
# 	@seeclass 
# } 
# 
#*/###########################################################################
setMethodS3(
	"getSite", 
	class="Event", 
	function(
		this,
		...
	){
		
		this$.site;

	},
	private=FALSE,
	protected=FALSE,
	overwrite=FALSE,
	conflict="warning",
	validators=getOption("R.methodsS3:validators:setMethodS3")
);

##	
## Method: getPosition
##	
###########################################################################/**
#
# @RdocMethod getPosition
# 
# @title "Get the position of the Site object associated to an Event object in the enclosing Sequence object" 
# 
# \description{ 
#	@get "title".
# } 
# 
# @synopsis 
# 
# \arguments{ 
# 	\item{this}{An Event object.} 
# 	\item{...}{Not used.} 
# } 
# 
# \value{ 
# 	A numeric vector of length one.
# } 
# 
# \examples{
#	# create a sequence and attach a process
#	s<-NucleotideSequence(string="ATGC",processes=list(list(JC69())))
#	# get the first active event from the first site
#	e<-getEvents(s,1)[[1]]
#	# get the position of the site associated with e
#	getPosition(e)
#	# get position via virtual field
#	e$position
# } 
# 
# @author 
# 
# \seealso{ 
# 	@seeclass 
# } 
# 
#*/###########################################################################
setMethodS3(
	"getPosition", 
	class="Event", 
	function(
		this,
		...
	){
		
		this$.position;

	},
	private=FALSE,
	protected=FALSE,
	overwrite=FALSE,
	conflict="warning",
	validators=getOption("R.methodsS3:validators:setMethodS3")
);

##	
## Method: setPosition	A function object.
##	
###########################################################################/**
#
# @RdocMethod setPosition
# 
# @title "Set the position of the Site object associated to an Event object" 
# 
# \description{ 
#	@get "title".
#	
#	The position field is usually not modified directly, but set by the \code{getEvents.Sequence} method. 
#	The position is *not* set by Site methods as \code{getEventsAtSite.Site}.
# } 
# 
# @synopsis 
# 
# \arguments{ 
# 	\item{this}{An Event object.} 
# 	\item{value}{The position.} 
# 	\item{...}{Not used.} 
# } 
# 
# \value{ 
# 	The new position (invisible).
# } 
# 
# \examples{
#	# Note: the following example is not too useful	
#
#	# create a sequence and attach a process
#	s<-NucleotideSequence(string="ATGC",processes=list(list(JC69())))
#	# get the first active event from the first site
#	e<-getEvents(s,1)[[1]]
#	# get event position
#	e$position
#	# set the position of the site associated with e
#	setPosition(e,2)
#	# get position via virtual field
#	e$position
#	# set position via virtual field
#	e$position<-1
#	e$position
# } 
# 
# @author 
# 
# \seealso{ 
# 	@seeclass 
# } 
# 
#*/###########################################################################
setMethodS3(
	"setPosition", 
	class="Event", 
	function(
		this,
		value,
		...
	){

	if(!exists(x="PSIM_FAST")){
		if(is.na(this$.site)){
			throw("There is no associated Site object!\n");
		}	
		if(is.na(this$.site$.sequence)){
			throw("The site is not part of any sequence!\n");	
		}
		if(value > this$.site$.sequence$.length | value < 1) {
			throw("Invalid position!\n");
		}
	}
		this$.position<-value;

	},
	private=FALSE,
	protected=FALSE,
	overwrite=FALSE,
	conflict="warning",
	validators=getOption("R.methodsS3:validators:setMethodS3")
);

##	
## Method: setSite
##	
###########################################################################/**
#
# @RdocMethod setSite
# 
# @title "Assotiate an Event object with a Site object" 
# 
# \description{ 
#	@get "title".
# } 
# 
# @synopsis 
# 
# \arguments{ 
# 	\item{this}{An Event object.} 
# 	\item{new.site}{A valid Site object.} 
# 	\item{...}{Not used.} 
# } 
# 
# \value{ 
# 	The new associated Site object (invisible).
# } 
# 
# \examples{
#	# create an Event object
#	e<-Event()
#	# create some Site objects
#	s1<-Site(alphabet=NucleotideAlphabet(),state="A")
#	s2<-clone(s1); s2$state<-"T"
#	# assotiate s1 with e
#	setSite(e,s1)
#	e$site
#	# assotiate s2 with e via virtual field
#	e$site<-s2
#	e$site
# } 
# 
# @author 
# 
# \seealso{ 
# 	@seeclass 
# } 
# 
#*/###########################################################################
setMethodS3(
	"setSite", 
	class="Event", 
	function(
		this,
		new.site,
		...
	){
			
		.checkWriteProtection(this);	
	if(!exists(x="PSIM_FAST")){
		if (!is.Site(new.site)) {throw("Site object invalid!\n")}
		new.site<-enableVirtual(new.site);
		if(missing(new.site)) {throw("No site given")}

		else if (!is.na(this$process)){
				if (this$.process$.alphabet != new.site$.alphabet){
					throw("The site and process alphabets are incompatible!\n");
			}
		}
	}
		this$.site<-new.site;
		invisible(this$.site)
		
	
	},
	private=FALSE,
	protected=FALSE,
	overwrite=FALSE,
	conflict="warning",
	validators=getOption("R.methodsS3:validators:setMethodS3")
);

##	
## Method: Perform
##	
###########################################################################/**
#
# @RdocMethod Perform
# 
# @title "Perform an event" 
# 
# \description{ 
#
#	Performing an event means that the modifications described by the Event object are actually made by calling
#	the event handler function as returned by \code{getHandler} with the Event object as the first argument.
#
#	The event won't be performed if the handler function is invalid, if there is no associated Site object, 
#	if the site position is undefined, if the rate is undefined, or if the generator process is invalid.
#
#	The handler function will be overwritten after performing an event, so the Perform method should be called
#	only once for every Event object.
# } 
# 
# @synopsis 
# 
# \arguments{ 
# 	\item{this}{An Event object.} 
# 	\item{...}{Not used.} 
# } 
# 
# \value{ 
# 	The value returned by the handler function.
# } 
# 
# \examples{
#	# create a sequence and attach a process
#	s<-NucleotideSequence(string="ATGC",processes=list(list(JC69())))
#	# get the first active event from the first site
#   #only Sequence methods set .position, 
#   #so s$sites[[1]]$events[[1]] wouldn't work.
#	e<-getEvents(s,1)[[1]]	
#	# perform e
#	Perform(e)
#	# check the effect of the event on s
#	s
# } 
# 
# @author 
# 
# \seealso{ 
# 	@seeclass 
# } 
# 
#*/###########################################################################
setMethodS3(
	"Perform", 
	class="Event", 
	function(
		this,
		...
	){
	
	if(!exists(x="PSIM_FAST")){
		if(!is.function(this$.handler)){throw("Event handler is not a function!\n")}		
		else if (!is.Site(this$.site)){throw("The site associated with the event is not valid!\n")}
		else if(is.null(this$.position)){throw("The target site position is unknown!Refusing to perform event!\n")}
		else if (!is.Process(this$.process)) {
			throw("The event has no generator process. Refusing to perform!\n");
		}
		else if (is.na(this$.rate)) {
			throw("The event has no rate. Refusing to perform!\n");
		}
	}
			# Better not perform anything on a dirty object!
			if(this$.site$.sequence$.cumulative.rate.flag) {
				.recalculateCumulativeRates(this$.site$.sequence);
			}
			# Do NOT flag cumulative rate! The event should take care of that!

			# Flag site if we deal with substitutions:
			if( is.GeneralSubstitution( getProcess(this) ) ) {
				this$.site$.sequence$.flagged.sites<-c(this$.site$.sequence$.flagged.sites, this$.position);
			}

			# Call the event handler to perform event:
			output<-this$.handler(this);

			# Event will self-destruct to prevent trouble:
			
			if(!exists(x="PSIM_FAST")){
			
			this$.handler<-function(event=this) { throw("You can perform an event only once!\n") };
			}

			return(output);
	
	},
	private=FALSE,
	protected=FALSE,
	overwrite=FALSE,
	conflict="warning",
	validators=getOption("R.methodsS3:validators:setMethodS3")
);


##	
## Method: .setHandler
##	
setMethodS3(
	".setHandler", 
	class="Event", 
	function(
		this,
		new.handler,
		...
	){
		if(!exists(x="PSIM_FAST")){
		if(missing(new.handler)){throw("No new handler provided!\n")}
		else if (!is.function(new.handler)){throw("The handler must be a function!\n")}
		}
		this$.handler<-new.handler;

	},
	private=FALSE,
	protected=FALSE,
	overwrite=FALSE,
	conflict="warning",
	validators=getOption("R.methodsS3:validators:setMethodS3")
);

##
## Method: getWriteProtected
##
###########################################################################/**
#
# @RdocMethod getWriteProtected
#  
# @title "Check if the object is write protected" 
# 
# \description{ 
#	@get "title".
#	Write protected objects cannot be modified through get/set methods and virtual fields.
# } 
# 
# @synopsis 
# 
# \arguments{ 
# 	\item{this}{An object.} 
# 	\item{...}{Not used.} 
# } 
# 
# \value{ 
# 	TRUE or FALSE
# } 
# 
# \examples{
#
#       # create an object
#       o<-Event()
#       # toggle write protection
#       o$writeProtected<-TRUE
#       # check if it's write protected
#       getWriteProtected(o)
#       # check write protection via virtual field
#       o$writeProtected
#	
# } 
# 
# @author 
# 
# \seealso{ 
# 	@seeclass 
# } 
# 
#*/###########################################################################
setMethodS3(
  "getWriteProtected",
  class="Event",
  function(
    this,
    ...
  ){

    this$.write.protected;

  },
  private=FALSE,
  protected=FALSE,
  overwrite=FALSE,
  conflict="warning",
  validators=getOption("R.methodsS3:validators:setMethodS3")
);

##
## Method: setWriteProtected
##
###########################################################################/**
#
# @RdocMethod setWriteProtected
#  
# @title "Set the write protection field for an object" 
# 
# \description{ 
#	@get "title".
#	Write protected objects cannot be modified through get/set methods and virtual fields.
# } 
# 
# @synopsis 
# 
# \arguments{ 
# 	\item{this}{An object.} 
# 	\item{value}{A logical vector of size one.} 
# 	\item{...}{Not used.} 
# } 
# 
# \value{ 
# 	Invisible TRUE or FALSE.
# } 
# 
# \examples{
#
#	# create an object
#	o<-Event()
#	# toggle write protection
#	setWriteProtected(o,TRUE)
#	# check write protection
#	o$writeProtected
#	# set write protection via virtual field
#	o$writeProtected<-FALSE
#	o$writeProtected
#	
#	
# } 
# 
# @author 
# 
# \seealso{ 
# 	@seeclass 
# } 
# 
#*/###########################################################################
setMethodS3(
  "setWriteProtected",
  class="Event",
  function(
    this,
    value,
    ...
  ){

    if(!exists(x="PSIM_FAST")){
    	if(!is.logical(value)) {throw("The new value must be logical!\n")}
    }
    this$.write.protected<-value;

  },
  private=FALSE,
  protected=FALSE,
  overwrite=FALSE,
  conflict="warning",
  validators=getOption("R.methodsS3:validators:setMethodS3")
);

##
## Method: .checkWriteProtection
##
setMethodS3(
  ".checkWriteProtection",
  class="Event",
  function(
    this,
    value,
    ...
  ){

    if(exists(x="PSIM_FAST")){return(FALSE)}
    if(this$writeProtected) {throw("Cannot set value because the object is write protected!\n")}
    else {return(FALSE)}

  },
  private=FALSE,
  protected=FALSE,
  overwrite=FALSE,
  conflict="warning",
  validators=getOption("R.methodsS3:validators:setMethodS3")
);

##
## Method: checkConsistency
##
###########################################################################/**
#
# @RdocMethod	checkConsistency
# 
# @title "Check object consistency"
# 
# \description{ 
#		@get "title".
# } 
# 
# @synopsis 
#
# \arguments{ 
#       \item{this}{An object.} 
#       \item{...}{Not used.} 
# } 
# 
# 
# \value{ 
#		Returns an invisible TRUE if no inconsistencies found in the object, throws 
#		an error otherwise. 
# } 
# 
# @author 
# 
# \seealso{ 
# 	@seeclass 
# } 
# 
#*/###########################################################################
setMethodS3(
  "checkConsistency",
  class="Event",
  function(
    this,
    ...
  ){
		
		wp<-this$writeProtected;
		if(wp) {
			this$writeProtected<-FALSE;
		}

		may.fail<-function(this) {

			if (is.null(this$.name)){
				throw("Event name is NULL!\n");
			}
			else if (!is.na(this$.name))	{
				this$name<-this$name;
			}

			if (is.null(this$.rate)){
				throw("Event rate is NULL!\n");
			}
			else if (!is.na(this$.rate))	{
				this$rate<-this$rate;
			}


			if (is.null(this$.process)){
				throw("Event rate is NULL!\n");
			}
			else if (!is.na(this$.process))	{
				this$process<-this$process;
			}

			if (is.null(this$.site)){
				throw("Event site is NULL!\n");
			}
			else if (!is.na(this$.site))	{
				this$site<-this$site;
			}

		}
		tryCatch(may.fail(this), finally=this$writeProtected<-wp);

		return(invisible(TRUE))	

  },
  private=FALSE,
  protected=FALSE,
  overwrite=FALSE,
  conflict="warning",
  validators=getOption("R.methodsS3:validators:setMethodS3")
);


##	
## Method: as.character.Event
##	
###########################################################################/**
#
# @RdocMethod as.character
# 
# @title "Get the character representation of an Event object" 
# 
# \description{ 
#	@get "title".
#
#	The character represenation of an Event object has the following format: 
#	"event name" ("event rate") <-- "generator process id", like \code{"A->T (0.333333333333333) <-- JC69:Anonymous:44780832"}.
# } 
# 
# @synopsis 
# 
# \arguments{ 
# 	\item{x}{An Event object.} 
# 	\item{...}{Not used.} 
# } 
# 
# \value{ 
# 	A character vector of length one.
# } 
# 
# \examples{
#	# create a sequence and attach a process
#	s<-NucleotideSequence(string="ATGC",processes=list(list(JC69())))
#	# get the first active event from the first site
#	e<-s$sites[[1]]$events[[1]]
#	# get the character representation of e
#	as.character(e)
#	# or more simply
#	e
# } 
# 
# @author 
# 
# \seealso{ 
# 	@seeclass 
# } 
# 
#*/###########################################################################
setMethodS3(
	"as.character", 
	class="Event", 
	function(
		x,
		...
	){
		
		this<-x;
		procid<-NA;
		if(!is.na(this$.process)){
			procid<-this$.process$.id;
		}	
		paste(this$.name," (",this$.rate,")"," <-- ",procid,sep="");	
		
	},
	private=FALSE,
	protected=FALSE,
	overwrite=FALSE,
	conflict="warning",
	validators=getOption("R.methodsS3:validators:setMethodS3")
);

##	
## Method: summary.Event
##	
###########################################################################/**
#
# @RdocMethod summary
#
# @title "Summarize the properties of an object"
#
# \description{
#       @get "title".
# }
#
# @synopsis
#
# \arguments{
#       \item{object}{An object}
#       \item{...}{Not used.}
# }
#
# \value{
#  Returns a PSRootSummary object.
# }
#
# \examples{
#
#       # create an object
#       e<-Event()
#       # get a summary
#       summary(e)
# }
#
# @author
#
# \seealso{
#       @seeclass
# }
#
#*/###########################################################################
setMethodS3(
	"summary", 
	class="Event", 
	function(
		object,
		...
	){
		
		this<-object;	
		this$.summary$"Name"<-this$.name;	
		this$.summary$"Rate"<-this$.rate;	

		procid<-NA;
		if(!is.na(this$.process)){
			procid<-this$.process$id;
		}	
		this$.summary$"Generator process"<-procid;
		
		site.state<-NA;
		if(!is.na(this$.site)){
			site.state<-getState(this$.site);
		}	
		
		this$.summary$"Target site state"<-site.state;
		if(this$writeProtected) {
			this$.summary$"Write protected"<-TRUE;
		}
		
		NextMethod();		
	},
	private=FALSE,
	protected=FALSE,
	overwrite=FALSE,
	conflict="warning",
	validators=getOption("R.methodsS3:validators:setMethodS3")
);

