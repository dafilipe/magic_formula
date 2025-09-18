tic



% main_script.m

% Definições
Hoosier = 'Hoosier 20.5X7.0-13, R20';
Goodyear ='Goodyear 20.0X7.0-13';
Hoosier_18 = 'Hoosier 18.0X6.0-10';
Goodyear_18 ='Goodyear 18.0X6.5-10, Eagle Racing Special';
MRF ='MRF 18.0X6.0-10, ZTD1';
tol = 100;
rimWidth = 7.0;
minfich = 16;
maxfich = 79;
choice = 0;    
testChoice = 0; % 1 = Cornering, 2 = Drive/Brake

%tipo de pneu
fprintf("Escolhe o tipo de pneu para estudo:")
fprintf(" Hoosier 20.5X7.0-13, R20 :1\n Goodyear 20.0X7.0-13:2\n Hoosier 18.0X6.0-10:3\n Goodyear 18.0X6.5-10, Eagle Racing Special:4\n MRF 18.0X6.0-10, ZTD1:5\n");
choice = input('');
switch choice
    case 1, tireName = Hoosier;
    case 2, tireName = Goodyear;
    case 3, tireName = Hoosier_18;
    case 4, tireName = Goodyear_18;
    case 5, tireName = MRF;
    otherwise, error('Opção inválida.');
end

clc

%tipo de teste
fprintf ("Escolhe que tipo de testes queres recolher \n Cornering-1 \n Drive Brake-2\n");
testChoice = input('');

    if testChoice == 1
        folderPath = 'RawData_Cornering_ASCII_SI_Round9_Runs16to49';
        fprintf("Cornering selecionado\n");
    elseif testChoice == 2  
        folderPath = 'RawData_DriveBrake_ASCII_SI_Round9';
        fprintf("DriveBrake selecionado\n");
    else
        error('Opção inválida. Escolhe 1 (cornering) ou 2 (drivebrake).');
    end


% Chamada da função
[SA, FZ, FY, MZ] = read_calspan_data(folderPath,tireName, rimWidth, minfich, maxfich);

figure; plot(SA, FY); xlabel('Slip Angle (deg)'); ylabel('Lateral Force FY (N)'); title(sprintf('FY vs SA - %s', tireName)); grid on;

% Exemplo de visualização

toc