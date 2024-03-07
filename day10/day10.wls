#!/usr/bin/env wolframscript
(* ::Package:: *)

(* ::Input:: *)
(*data = Import["inputs/input.txt","List"];*)


(* ::Input:: *)
(*Dimensions[data]*)


(* ::Input:: *)
(*pipes = StringSplit[#,""]& /@data*)


(* ::Input:: *)
(*pipes*)


(* ::Input:: *)
(*Dimensions[pipes]*)


(* ::Input:: *)
(*start = Flatten[Position[pipes,"S"]] *)


(* ::Input:: *)
(*pipes[[start[[1]],start[[2]]]]*)


(* ::Input:: *)
(*pipeTypes=<|"|"->{"Down","Up"},"-"->{"Left","Right"},"F"->{"Down","Right"},"7"->{"Left","Down"},"J"->{"Left","Up"},"L"->{"Up","Right"}|>*)


(* ::Input:: *)
(*getExitDirection[currentPipe_,enteredFrom_]:=Complement[pipeTypes[currentPipe],{enteredFrom}][[1]];*)


(* ::Input:: *)
(*getExitDirection["F","Right"]*)


(* ::Input:: *)
(*getNewLocation[row_,column_,motion_]:=Switch[motion,*)
(*	"Up",Return[{row-1,column}],*)
(*	"Down",Return[{row+1,column}],*)
(*	"Left",Return[{row,column-1}],*)
(*	"Right",Return[{row,column+1}]*)
(*];*)


(* ::Input:: *)
(*getNewLocation[4,5,"Left"]*)


(* ::Input:: *)
(*getNextEnterDirection[direction_]:= Switch[direction,*)
(*"Left",Return["Right"],*)
(*"Right",Return["Left"],*)
(*"Up",Return["Down"],*)
(*"Down",Return["Up"]*)
(*];*)


(* ::Input:: *)
(*getNextEnterDirection["Left"]*)


(* ::Input:: *)
(*execMove[row_,column_,enteredFrom_]:=*)
(*Module[{currentPipe, exitDirection,newEnterDirection, newRow,newColumn},*)
(*currentPipe=pipes[[row,column]];*)
(*exitDirection = getExitDirection[currentPipe,enteredFrom];*)
(*{newRow, newColumn} = getNewLocation[row,column,exitDirection];*)
(*newEnterDirection = getNextEnterDirection[exitDirection];*)
(*Return[{newRow, newColumn,newEnterDirection}]*)
(*];*)


(* ::Input:: *)
(*row=1;column=1;enteredFrom="Right";*)


(* ::Input:: *)
(*execMove[row,column,enteredFrom];*)


(* ::Input:: *)
(*{row,column,enteredFrom}= execMove[row,column,enteredFrom];*)


(* ::Input:: *)
(*row=start[[1]]+1;column=start[[2]];enteredFrom="Up";*)


(* ::Input:: *)
(*{row,column,enteredFrom}=execMove[row,column,enteredFrom];*)


(* ::Input:: *)
(*getSegmentArea[row_,column_,enteredFrom_]:=Switch[*)
(*enteredFrom,*)
(*"Left",Return[+0.5*(+1)(row)-0.5],*)
(*"Right",Return[+0.5*(-1)*(row)-0.5],*)
(*"Up",Return[+0.5*(-1)*(column)-0.5],*)
(*"Down",Return[+0.5*(+1)*(column)-0.5]*)
(*];*)


(* ::Input:: *)
(*getIndexChange[enteredFrom_]:=Switch[*)
(*enteredFrom,*)
(*"Left",Return[{0,1}],*)
(*"Right",Return[{0,-1}],*)
(*"Up",Return[{1,0}],*)
(*"Down",Return[{-1,0}]*)
(*];*)


(* ::Input:: *)
(*countCycle[startLocation_]:=Module[*)
(*{row,column,enteredFrom,numSteps,foundStart,areaTotal,areaGain,cw},*)
(* (*column+1 happens to be CCW for main problem*)*)
(*enteredFrom="Left";*)
(*{row,column}={startLocation[[1]],startLocation[[2]]}+getIndexChange[enteredFrom];*)
(*cw=True;*)
(*numSteps=1;*)
(*areaTotal=getSegmentArea[row,column,enteredFrom];*)
(*While[True,*)
(*{row,column,enteredFrom}= execMove[row,column,enteredFrom];*)
(*numSteps=numSteps+1;*)
(*areaTotal=areaTotal+getSegmentArea[row,column,enteredFrom];*)
(*If[pipes[[row,column]]=="S",Print["ReachedS"];Break[];,Null];*)
(*If[numSteps>20000,Print["NotFoundStart"];Break[],Null];*)
(*];*)
(*areaTotal+=1; (*we are doubly counting in the horizontal and vertical corrections*);*)
(*Print["FoundStart!"];*)
(*Return [{numSteps,areaTotal}]*)
(*];*)


(* ::Input:: *)
(*countCycle[start]*)


(* ::Input:: *)
(*start*)


(* ::Input:: *)
(*countCycleWithPlot[startLocation_]:=Module[*)
(*{row,column,enteredFrom,numSteps,foundStart,areaTotal,areaGain,cw},*)
(*enteredFrom="Left";*)
(*{row,column}={startLocation[[1]],startLocation[[2]]}+getIndexChange[enteredFrom];*)
(*cw=True;*)
(*numSteps=1;*)
(*areaTotal=getSegmentArea[row,column,enteredFrom];*)
(*While[True,*)
(*table=AppendTo[table,{column,-row}];*)
(*{row,column,enteredFrom}= execMove[row,column,enteredFrom];*)
(*numSteps=numSteps+1;*)
(*areaTotal=areaTotal+getSegmentArea[row,column,enteredFrom];*)
(**)
(*If[pipes[[row,column]]=="S",Print["ReachedS"];Break[];,Null];*)
(*If[numSteps>20000,Print["NotFoundStart"];Break[],Null];*)
(*];*)
(*Print["FoundStart!"];*)
(*areaTotal+=1;*)
(*table=AppendTo[table,{column,-row}];*)
(*Return [{numSteps,areaTotal}]*)
(*];*)
(*ClearAll[table];*)
(*table={};*)
(*table=AppendTo[table,{column,-row}];*)
(**)
(*countCycleWithPlot[start]*)


(* ::Input:: *)
(*grids[min_,max_]:=Table[If[EvenQ[i],{i,Red},{i,Blue}],{i,Ceiling[min],Floor[max],1}];*)
(*lineplot = ListLinePlot[table,GridLines->grids, Epilog->{Red,PointSize@Large,Point[{start[[2]],-start[[1]]}]}]*)
