/* ----------------------------------------------------------------
 | X macro to generate random pseudo-text - use: foggy [n] | [?]
 | "Ported" from FOGGY.ERX, an EPM macro
  ----------------------------------------------------------------- */
arg times
/* List of LEADINS, all of which mean nothing but buy time */
leadin.1  = "In particular,"
leadin.2  = "On the other hand,"
leadin.3  = "However,"
leadin.4  = "Similarly,"
leadin.5  = "As a resultant implication,"
leadin.6  = "In this regard,"
leadin.7  = "Based on integral subsystem considerations,"
leadin.8  = "For example,"
leadin.9  = "Thus,"
leadin.10 = "In respect to specific goals,"
leadin.11 = "Interestingly enough,"
leadin.12 = "Without going into the technical details,"
leadin.13 = "Of course,"
leadin.14 = "To approach true user-friendliness,"
leadin.15 = "In theory,"
leadin.16 = "It is assumed that"
leadin.17 = "Conversely,"
leadin.18 = "We can see, in retrospect,"
leadin.19 = "It is further assumed that"
leadin.20 = "Further,"
leadin.21 = "In summary,"
leadin.22 = "It should be noted that"
leadin.23 = "To further describe and annotate,"
leadin.24 = "Specifically,"
/* additions */
leadin.25 = "That is not to say, however, that"
leadin.26 = "This in no way precludes that"
leadin.0  = 26

/* List of SUBJECT clauses chosen for no redeeming value whatsoever */
subject.1  = "a large segment of disgruntled former employee mitigation"
subject.2  = "a continual promotion of defect enhancements"
subject.3  = "the characterization of root cause deficiencies"
subject.4  = "initiation of critical subprogram configuration"
subject.5  = "the fully integrated status update feedback mechanism"
subject.6  = "the corporate policy portal content specification"
subject.7  = "any high-priority client impact"
subject.8  = "the incorporation of additional legal hold dependencies"
subject.9  = "the likelihood of development assistance"
subject.10 = "the interrelation of test and/or release environments"
subject.11 = "the performance metric architecture"
subject.12 = "the asynchronous insertion of duplicate reversal transactions"
subject.0  = 12

/* List of VERB clauses chosen for auto-recursive obfuscation */
verb.1  = "must utilize and be functionally interwoven with"
verb.2  = "maximizes the probability of project success, yet minimizes cost and time required for"
verb.3  = "adds explicit performance limits to"
verb.4  = "necessitates that urgent consideration be applied to"
verb.5  = "requires considerable systems analysis and trade-off studies to arrive at"
verb.6  = "is further compounded when taking into account"
verb.7  = "presents extremely interesting challenges to"
verb.8  = "recognizes other systems' importance and the necessity for"
verb.9  = "implicitly declines all transactions related to"
verb.10 = "adds overriding performance constraints to"
verb.11 = "mandates scrum-meeting-level attention to"
verb.12 = "is functionally equivalent and parallel to"
verb.0  = 12

/* List of OBJECT clauses selected for profound meaninglessness */
object.1  = "the most recent issues log completion.  "
object.2  = "the anticipated client change request submission.  "
object.3  = "the subsystem compatibility testing.  "
object.4  = "back office legacy compatibility, based on business approval delay probabilities. "
object.5  = "the communication status activation value.  "
object.6  = "the identification of defects or enhancements over a given time period. "
object.7  = "the philosophy of commonality and standardization.  "
object.8  = "the greater fight-worthiness concept.  "
object.9  = "any pre-denominated subprogram value. "
object.10 = "the management-by-contention principle.  "
object.11 = "the explicit volume normalization rationale.  "
object.12 = "the postulated use of post implementation test procedures.  "
object.13 = "the overall negative profitability.  "
object.14 = "the inherent confusion associated with incorrect requirements delineation.  "
object.15 = "any client or affiliate entitled 'First Bank of Snook'.  "
object.0  = 15

if times='?' then do
  "MSG foggy howManyLines"
  "alt 0 0"
  exit
end

if times='' then times=1

leadnum = 0
subnum  = 0
verbnum = 0
objnum  = 0
lastlead = leadnum
lastsub  = subnum
lastverb = verbnum
lastobj  = objnum
output = ''
linesize = 64

/* And, last but not least, here's the program */
do i=1 to times
  do while leadnum = lastlead
    leadnum = RANDOM(1, leadin.0)
  end

  do while subnum = lastsub
    subnum = RANDOM(1, subject.0)
  end

  do while verbnum = lastverb
    verbnum = RANDOM(1, verb.0)
  end

  do while objnum = lastobj
    objnum = RANDOM(1, object.0)
  end

  output = output leadin.leadnum subject.subnum verb.verbnum object.objnum

  lastlead = leadnum;
  lastsub  = subnum;
  lastverb = verbnum;
  lastobj  = objnum;
end

/* OK, now lets put that data out NICELY */
'EXTRACT /CURLINE/'
blanks=max(verify(CURLINE.1, ' ')-1,0)
do until output = ''
  k=LASTPOS(' ',output,MIN(linesize,LENGTH(output)))
  'INPUT' copies(' ', blanks)||strip(LEFT(output,k))
  output=STRIP(SUBSTR(output,k+1),'L')
end
exit
