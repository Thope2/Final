function [] = VanDerWaals()
close all;
global gui;
%Calculate and clear button
    gui.fig = figure('numbertitle','off','name','Van Der Waals');
    gui.calculateVol = uicontrol('style','pushbutton','units','normalized','position',[.034 .45 .14 .05],'string','Calculate','callback',{@CalculateVol});
    gui.clear = uicontrol('style','pushbutton','units','normalized','position',[.84 .45 .14 .05],'string','Clear All','callback',{@Clear});
 
%Celsius or kelvin button 
    gui.buttonGroupTemp = uibuttongroup('visible','on','unit','normalized','position',[.2 .9 .20 .08],'selectionchangedfcn',{@radioSelectTemp});
    gui.radioButtonsTemp{1} = uicontrol(gui.buttonGroupTemp,'style','radiobutton','units','normalized','position',[.0 .25 1 .45],'HandleVisibility','off','string','Kelvin');
    gui.radioButtonsTemp{2} = uicontrol(gui.buttonGroupTemp,'style','radiobutton','units','normalized','position',[.50 .25 1 .45],'HandleVisibility','off','string','Celsius');
    
%ATM or Pascals button
    gui.buttonGroupPres = uibuttongroup('visible','on','unit','normalized','position',[.6 .9 .2 .08],'selectionchangedfcn',{@radioSelectPres});
    gui.radioButtonsPres{1} = uicontrol(gui.buttonGroupPres,'style','radiobutton','units','normalized','position',[.0 .25 1 .45],'HandleVisibility','off','string','Pascals');
    gui.radioButtonspres{2} = uicontrol(gui.buttonGroupPres,'style','radiobutton','units','normalized','position',[.57 .25 1 .45],'HandleVisibility','off','string','ATM');
    
%where you type in you numbers
    gui.PrestextBox =uicontrol('style','edit','units','normalized','position',[.10 .80 .18 .06],'string','Pressure');
    gui.TemptextBox =uicontrol('style','edit','units','normalized','position',[.30 .80 .18 .06],'string','Temperature');
    gui.CritTemptextBox = uicontrol('style','edit','units','normalized','position',[.50 .80 .18 .06],'string','Critical Temperature');
    gui.CritPrestextBox = uicontrol('style','edit','units','normalized','position',[.70 .80 .18 .06],'string','Critical Pressure');
 
%a and b lables
    gui.IMVAtextBox = uicontrol('style','text','units','normalized','position',[.55 .70 .18 .06],'string','Empirical Constant a');
    gui.IMVBtextBox = uicontrol('style','text','units','normalized','position',[.25 .70 .18 .06],'string','Empirical Constant b ');
    
%the value of a and b
    gui.IMVAvalueBox = uicontrol('style','text','units','normalized','position',[.55 .65 .18 .06],'string','0');
    gui.IMVBvalueBox = uicontrol('style','text','units','normalized','position',[.25 .65 .18 .06],'string','0');

% volume display 
    gui.VolmtextBox = uicontrol('style','text','units','normalized','position',[.42 .6 .18 .06],'string','Spicific Volume (m^3/moles)');
    gui.VolmvalueBox = uicontrol('style','text','units','normalized','position',[.42 .54 .18 .03],'string','0');

% New volume display and inputs
    gui.AdiabaticalFactorLable = uicontrol('style','text','units','normalized','position',[.375 .42 .25 .06],'string','Adiabatical Compression');
    gui.calculateVol2 = uicontrol('style','pushbutton','units','normalized','position',[.4 .02 .2 .05],'string','Calculate Final Volume','callback',{@CalculateVol2});
    gui.NewPrestextBox = uicontrol('style','edit','units','normalized','position',[.4 .35 .2 .06],'string','Final Pressure');
    gui.AdiabaticalFactortextBox = uicontrol('style','edit','units','normalized','position',[.4 .25 .2 .06],'string','Adiabatic Factor');
    gui.NewVolvalueBox = uicontrol('style','text','units','normalized','position',[.4 .07 .2 .06],'string','0');
    gui.VolmtextBox = uicontrol('style','text','units','normalized','position',[.42 .15 .18 .06],'string','Final Spicific Volume (m^3/moles)');
end
%finds out in units are kelvin or Celsius
function [] = radioSelectTemp(~,~,~)
global gui;
gui.typeTemp = gui.buttonGroupTemp.SelectedObject.String;
end

%finds out if units are Pascals or ATM
function [] = radioSelectPres(~,~,~)
global gui; 
gui.typePres = gui.buttonGroupPres.SelectedObject.String;
end

function [] = CalculateVol (~,~,~)
global gui;
%defining the variables.
    CT = str2double(gui.CritTemptextBox.String);
    CP = str2double(gui.CritPrestextBox.String);
    P = str2double(gui.PrestextBox.String);
    T = str2double(gui.TemptextBox.String);
     
    % Makes sure everything inserted in a number and not a word.
        if isnan(CT)
            msgbox('Critical Temperature is not a number!', 'Equation Error','error','modal')
            return
            else  
        end

        if isnan(CP)
            msgbox('Critical Pressure is not a number!', 'Equation Error','error','modal')
            return
            else  
        end
        
        if isnan(P)
            msgbox('Pressure is not a number!', 'Equation Error','error','modal')
            return
            else  
        end

        if isnan(T)
            msgbox('Temperature is not a number!', 'Equation Error','error','modal')
            return
            else  
        end
 
%this changes celsius to kelivin because the units have to be in kelvin for the
%calculation 
if gui.typeTemp == "Celsius"
    gui.TemptextBox.String = str2double(gui.TemptextBox.String) + 273.15;
    gui.CritTemptextBox.String = str2double(gui.CritTemptextBox.String) + 273.15;
end

%this changes ATM to Pascals because the units have to be in Pascals for the
%calculation        
if gui.typePres == "ATM"
     gui.PrestextBox.String = str2double(gui.PrestextBox.String) * 101325;
     gui.CritPrestextBox.String = str2double(gui.CritPrestextBox.String) * 101325;
end

%this defins the variables
    CT = str2double(gui.CritTemptextBox.String);
    CP = str2double(gui.CritPrestextBox.String);
    P = str2double(gui.PrestextBox.String);
    T = str2double(gui.TemptextBox.String);
    
% doing the acual calulations
R = 8.31446261815324;
b =(R*CT)/(8*CP);
a = (27*(R^2)*(CT^2))/(64*CP);
C = [P,-((P*b)+(R*T)),a,(-a*b)];
V = roots(C);

%displaying the new data 
gui.IMVAvalueBox.String = a;
gui.IMVBvalueBox.String = b;

% this displayss the value that is a real number and not a complex numeber
% there is always 2 complex and 1 real number 
    if imag(V(1)) == 0
        gui.VolmvalueBox.String = V(1);
        gui.TheVol=V(1);
    elseif imag(V(2)) == 0
        gui.VolmvalueBox.String = V(2);
        gui.TheVol=V(2);
    else
        gui.VolmvalueBox.String = V(3);
        gui.TheVol=V(3);
    end


end

function [] = Clear(~,~,~)
global gui
%resetting all the text boxes 
gui.IMVAvalueBox.String = 0;
gui.IMVBvalueBox.String = 0;
gui.VolmvalueBox.String = 0;
gui.CritTemptextBox.String = 'Critical Temperature';
gui.CritPrestextBox.String = 'Critical Pressure';
gui.PrestextBox.String = 'Pressure';
gui.TemptextBox.String = 'Temperature';
gui.NewPrestextBox.String = 'New Pressure';
gui.AdiabaticalFactortextBox.String = 'Adiabatical Factor';
gui.NewVolvalueBox.String = '0';
end

function [] = CalculateVol2(~,~,~)
global gui
% This makes sure that the intial volume has been calculated
if str2double(gui.VolmvalueBox.String) == 0
    msgbox('Please calculate initail volume.', 'Equation Error','error','modal')
    return
end

%Define valrables
P1 = str2double(gui.PrestextBox.String);
V1 = gui.TheVol;
P2 = str2double(gui.NewPrestextBox.String);
AF = str2double(gui.AdiabaticalFactortextBox.String);

%makes sure the new imputed numbers are actaly numbers not words
        if isnan(P2)
            msgbox('Final Pressure is not a number!', 'Equation Error','error','modal')
            return
        else  
        end
        
        if isnan(AF)
            msgbox('Adiabatical Factor is not a number!', 'Equation Error','error','modal')
            return
        else  
        end
%converts  ATM to Pascals

if gui.typePres == "ATM"
     gui.NewPrestextBox.String = str2double(gui.NewPrestextBox.String) * 101325;
     P2 = str2double(gui.NewPrestextBox.String);
end

% actal caculation
V2=(((P1*(V1)^AF)/P2))^(1/AF);
%display the value
gui.NewVolvalueBox.String=V2;
end