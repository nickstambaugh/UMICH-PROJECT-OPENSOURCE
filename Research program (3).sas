PROC IMPORT 
DATAFILE='/home/u56440190/STA 216/TAPS/Copy of our dataset for SAS - Sheet1 (4).csv'
DBMS=CSV REPLACE OUT=START;
GETNAMES=YES;
RUN;



proc means data=START maxdec=3;
var FUELCOST LCOE TOTALELC CF AGE STATUS TYPE REACTORS RATEDMWE NETGEN SUMMERMW COMMISSIONAGE;
title "Numerical Summary Statistics";
title2 "Nicholas Stambaugh"; run;

PROC UNIVARIATE data=START plots;
var FUELCOST LCOE TOTALELC CF AGE STATUS TYPE REACTORS RATEDMWE  NETGEN SUMMERMW COMMISSIONAGE;
title "Basic Numerical Summary Statistics";
RUN; 

PROC SGPLOT data=START;
histogram AGE;
title "Histogram of Plant Age";
title2 "Nicholas Stambaugh";
RUN;


PROC SGPLOT data=START;
vbox LCOE /group=AGE;
title "Comparison Boxplot: LCOE per AGE";
title2 "Nicholas Stambaugh";
RUN;

PROC SGPLOT data=START;
vbox TOTALELC /group=AGE;
title "Comparison Boxplot: TOTALELC per AGE";
title2 "Nicholas Stambaugh";
RUN;

PROC SGPLOT data=START;
vbox TOTALELC /group=STATUS;
title "Comparison Boxplot: TOTALELC per STATUS";
title2 "Nicholas Stambaugh";
RUN;

PROC SGPLOT data=START;
vbox TOTALELC /group=TYPE;
title "Comparison Boxplot: TOTALELC per TYPE";
title2 "Nicholas Stambaugh";
RUN;

proc sgplot data=START;
HISTOGRAM LCOE;
title "histogram of our equation";
title2 "Nicholas Stambaugh";

proc sgplot data=START;
VBOX LCOE;
title "VBOX of our equation";
title2 "Nicholas Stambaugh";


proc sgplot data=START;
HISTOGRAM TOTALELC;
title "histogram of Total Electricity";
title2 "Nicholas Stambaugh";



ods graphics on;
PROC GLM data=START plots=diagnostics;
class CF AGE;
model TOTALELC = CF AGE CF*AGE ;
lsmeans CF*AGE / cl adjust=BON;
title 'ANOVA Model';
RUN;

ods graphics on;
PROC GLM data=START plots=diagnostics;
class CF AGE FUELCOST NETGEN STATUS TYPE REACTORS RATEDMWE TCC2021;
model TOTALELC = CF AGE STATUS TYPE REACTORS RATEDMWE TCC2021  FUELCOST NETGEN CF*AGE*FUELCOST*NETGEN*STATUS*TYPE*REACTORS*RATEDMWE*TCC2021 ;
lsmeans CF AGE STATUS TYPE REACTORS RATEDMWE TCC2021  FUELCOST NETGEN / cl adjust=BON;
title 'ANOVA Model';
RUN;

ods graphics on;
PROC GLM data=START plots=diagnostics;
class CF AGE FUELCOST NETGEN ;
model LCOE = CF AGE  FUELCOST NETGEN CF*AGE*FUELCOST*NETGEN ;
lsmeans CF*AGE*FUELCOST*NETGEN / cl adjust=BON;
title 'ANOVA Model';
RUN;

proc sgplot
data=START;
REG X= AGE Y=FUELCOST;
title "Scatterplot: Age vs ";
title2 "Nicholas Stambaugh";
run;

proc sgplot
data=START;
REG X= AGE Y=LCOE;
title "Scatterplot: Age vs LCOE";
title2 "Nicholas Stambaugh";
run;

proc sgplot
data=START;
REG X= AGE Y=TCC2020 / group=plant;

title "Scatterplot: Age vs TCC2020";
title2 "Nicholas Stambaugh";
run;

ods graphics on;
proc reg data=START plots=diagnostics;
model LCOE = FuelCost / CLB CLM CLI;
ID FuelCost;
title "SLR Model: LCOE = Fuel Cost";
title2 "Nicholas Stambaugh";

ods graphics on;
proc reg data=START plots=diagnostics;
model LCOE = FuelCost / CLB CLM CLI;
ID FuelCost;
title "SLR Model: LCOE = Fuel Cost";
title2 "Nicholas Stambaugh";

 ods graphics on;
proc reg data=START plots=diagnostics;
model AGE = THREEMILE / CLB CLM CLI;
ID THREEMILE;
title "SLR Model: AGE = THREEMILE";
title2 "Nicholas Stambaugh";

PROC UNIVARIATE data=START plots;
var THREEMILE;
title "Basic Numerical Summary Statistics";
RUN; 

proc univariate data = START noprint;
histogram AGE
/ 
normal ( 
   mu = est
   sigma = est
   color = blue
   w = 2.5 
)
barlabel = count
midpoints = 42 to 66 by 1;
run;
 