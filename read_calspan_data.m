function [SA, FZ, FY, MZ] = read_calspan_data(tireName, rimWidth, minfich, maxfich)

    % inicializar cell arrays para acumular dados
    SA_cell = {};
    FZ_cell = {};
    FY_cell = {};
    MZ_cell = {};


    % escolher tipo de teste
    fprintf("Escolhe que tipo de testes queres recolher \n Cornering-1 \n Drive Brake-2\n");
    choice = input('');

    if choice == 1
        folderPath = 'RawData_Cornering_ASCII_SI_Round9_Runs16to49';
        fprintf("Cornering selecionado\n");
    elseif choice == 2  
        folderPath = 'RawData_DriveBrake_ASCII_SI_Round9';
        fprintf("DriveBrake selecionado\n");
    else
        error('Opção inválida. Escolhe 1 (cornering) ou 2 (drivebrake).');
    end

    % loop pelos ficheiros
    for i = minfich:maxfich
        filename = sprintf('B2356raw%d.dat', i);
        filepath = fullfile(folderPath, filename);

        if exist(filepath, 'file')
            fid = fopen(filepath, 'r');
            if fid == -1
                warning("Não foi possível abrir o ficheiro: %s", filename);
                continue;
            end

            % ler primeira linha do header
            headerLine = fgetl(fid);

            % verificar pneu e jante
            tireCheck = contains(headerLine, tireName, 'IgnoreCase', true); 
            rimCheck  = contains(headerLine, sprintf('Rim_Width=%g', rimWidth));

            if ~tireCheck || ~rimCheck
                fprintf("Ficheiro %s ignorado (pneu ou jante não correspondem)\n", filename);
                fclose(fid);
                continue;
            end

            % saltar as próximas 2 linhas do header
            fgetl(fid); 
            fgetl(fid);

            % ler dados numéricos
            data = textscan(fid, repmat('%f',1,21), 'Delimiter', '\t');

            % adicionar aos cell arrays
            SA_cell{end+1} = data{4};
            FZ_cell{end+1} = data{11};
            FY_cell{end+1} = data{10};
            MZ_cell{end+1} = data{13};


            fclose(fid);

        else
            fprintf("Ficheiro não encontrado: %s\n", filename);
        end
    end

    % concatenar todos os vetores no final
    SA = vertcat(SA_cell{:});
    FZ = vertcat(FZ_cell{:});
    FY = vertcat(FY_cell{:});
    MZ=  vertcat(MZ_cell{:});
end
