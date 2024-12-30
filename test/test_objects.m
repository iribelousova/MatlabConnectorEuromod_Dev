clear;
clc;

addpath(fullfile(pwd),"functions")

modelPath='C:\EUROMOD_RELEASES_I6.0+';
mm=euromod(modelPath);

temp=mm.countries(1).policies(5);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(1).policies(5).functions(4);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(1).policies(5).functions(4).parameters(2);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(1).datasets(2);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(1).extensions(7);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(1).local_extensions(2);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(1);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(1).AT_2016;
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.AT.systems(6).AT_2012_a8;
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(1).systems(4).policies(5);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(1).systems(4).policies(5).functions(4);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(1).policies(30);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(1).policies(30);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(3).policies(26);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(4).systems(4).policies(4).functions(2).parameters(5);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(9).policies(3);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(1).systems(8).policies(2);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(1).policies(2).functions(1);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(1).systems(17).policies(39);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(2).policies(7).functions(11);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(2).policies(7).functions(11).extensions(2);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(5).systems(15).policies(32).functions;
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(2).policies(7).functions;
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(1).policies(10).extensions(1);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries('AT').systems('AT_2023').policies('bcc00_at');
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries('AT').datasets;
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries('IT').systems('IT_2021').datasets(4);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(1).policies(44);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries('ES').datasets;
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries('LV').datasets(7);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries('BG').systems(7).datasets;
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries('BG').systems(7).datasets(4);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries('BG').systems(7).datasets;
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries('DE').policies(7).functions(4);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries('HR').systems(8).policies;
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(25).systems;
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(2).policies;
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.MT.MT_2017.btuls_mt.BenCalc.parameters;
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(2).systems(9).policies(8);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries('DE').systems('DE_2019').policies(19).functions(3).parameters(2);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(25).systems(14);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(20).systems(14);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(2).policies(7).functions(11).extensions(2);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(7).policies(15).functions(6).parameters(4);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(7).systems(17).policies(26).functions(4);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(14).policies(19).functions(3).parameters(2);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.IT.policies(19).functions(3);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.HU.policies(19).functions(3).parameters(2);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(9).systems(7).policies;
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.HU.tin_hu.functions(3).parameters(2);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(8).systems(4).policies(7).functions(2).parameters;
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(7).systems(9).policies(15).functions(6).parameters;
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(9).systems(7).policies(51).functions;
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.LV.LV_2018.policies(20).functions;
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(7).policies(15).functions(6).parameters;
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(1).systems(8).policies(2).functions(1);
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.NL.NL_2015.chall_nl.ArithOp;
obj=TestClass(modelPath,temp);
obj.warnMessage;

temp=mm.countries(25).systems(16).policies(19).functions(3).parameters(2);
obj=TestClass(modelPath,temp);
obj.warnMessage;

rmpath(fullfile(pwd),"functions")

