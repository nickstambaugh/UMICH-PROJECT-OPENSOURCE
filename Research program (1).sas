PROC IMPORT 
DATAFILE='/home/u56440190/STA 216/TAPS/Copy of our dataset for SAS - Sheet1 (2).csv'
DBMS=CSV REPLACE OUT=START;
GETNAMES=YES;
RUN;



proc means data=START maxdec=3;
var FUELCOST LCOE TOTALELC CF AGE STATUS TYPE REACTORS RATEDMWE FUELCOST NETGEN SUMMERMW COMMISSIONAGE;
title "Numerical Summary Statistics";
title2 "Nicholas Stambaugh"; run;

PROC UNIVARIATE data=START plots;
var FUELCOST LCOE TOTALELC CF AGE STATUS TYPE REACTORS RATEDMWE FUELCOST NETGEN SUMMERMW COMMISSIONAGE;
title "Basic Numerical Summary Statistics";
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