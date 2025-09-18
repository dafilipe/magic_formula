function [SA, FZ, FY, MZ] = read_calspan_data(folderPath, tireName, rimWidth, minfich, maxfich)

    SA = [];
    FZ = [];
    FY = [];
    MZ = [];

    % Loop pelos ficheiros
    for i = minfich:maxfich
        filename = sprintf('B2356raw%d.dat', i);
        filepath = fullfile(folderPath, filename);

        if ~isfile(filepath)
            continue;
        end

        fid = fopen(filepath, 'r');
        if fid < 0, continue; end

        % Verificar pneu e jante
        headerLine = fgetl(fid);
        if ~contains(headerLine, tireName, 'IgnoreCase', true) || ...
           ~contains(headerLine, sprintf('Rim_Width=%g', rimWidth))
            fclose(fid);
            continue;
        end

        % Ler nomes das colunas e ignorar linha das unidades
        colNamesLine = fgetl(fid);
        fgetl(fid); % unidades

        colNames = strsplit(strtrim(colNamesLine), '\t');
        numCols = numel(colNames);

        % Índices das colunas desejadas
        idx_SA = find(strcmpi(colNames, 'SA'));
        idx_FZ = find(strcmpi(colNames, 'FZ'));
        idx_FY = find(strcmpi(colNames, 'FY'));
        idx_MZ = find(strcmpi(colNames, 'MZ'));

        if any([isempty(idx_SA), isempty(idx_FZ), isempty(idx_FY), isempty(idx_MZ)])
            fclose(fid);
            continue;
        end

        % Lê todos os dados como números
        format = repmat('%f', 1, numel(colNames));
        data = textscan(fid, format, 'Delimiter', '\t');
        fclose(fid);

        SA = [SA; data{idx_SA}];
        FZ = [FZ; data{idx_FZ}];
        FY = [FY; data{idx_FY}];
        MZ = [MZ; data{idx_MZ}];
    end

    if isempty(SA)
        error("Nenhum ficheiro válido foi lido.");
    end
end
