% �񎟌���Ԃɑ΂���P���p�[�Z�v�g����
function simplePerceptron(dataFile)
    %-------------
    % �f�[�^�ǂݍ���
    %-------------
    % �`����, �e�s�� [x���W, y���W, �N���X] �ł���CSV�t�@�C��.
    % �N���X��, 0 �������� 1 ��2��ނɂ̂ݑΉ�.
    data = csvread(dataFile);
    nCol = size(data,1);
    % �w�K�f�[�^��ǂݍ���.
    learningDataArray = cell(1,nCol);
    for i=1:1:nCol
        learningDataArray{i} = [data(i,1), data(i,2)];
    end
    % �e�w�K�f�[�^�ɑΉ������N���X��ǂݍ���.
    expectedClassArray = data(:,3);
    
    %-------------
    % �e�f�[�^������
    %-------------
    % �ő僋�[�v��
    nLoop = 100000;
    % ������
    nSolve = 0;
    % �d�݂̏����l. �����_���ɐݒ肷��.
    weightArray = randi([-1,1], 2+1, 1);
    % �w�K��
    learningRate = 0.5;
    % �T���v���f�[�^������x�N�g���֕ϊ�����.
    featureVectorArray = cell(1, size(learningDataArray,2));
    for i=1:1:size(learningDataArray,2)
        featureVectorArray{i} = [learningDataArray{i} 1];
    end
    
    %-------------
    % �w�K����
    %-------------
    for l=1:1:nLoop
        % �w�K�f�[�^�S�Ă�, ���ʊ֐���K�p����.
        for i=1:1:size(featureVectorArray, 2)
            % 1�̊w�K�f�[�^��, ���ʊ֐��ɓK�p����.
            calculatedClass = ...
                activationFunction(featureVectorArray{i},weightArray);
            
            if expectedClassArray(i) == calculatedClass
                % �������N���X�ł����, �L�^����.
                nSolve = nSolve + 1;
            else
                % �������Ȃ��N���X�ł����, �L�^���Ȃ�.
                % �@���҂���Ă����N���X�Ǝ��ۂɏo�͂��ꂽ�N���X�̍������Ƃ�,
                % �@�d�݂��X�V����.
                gapBetweenClasses = expectedClassArray(i)-calculatedClass;
                weightArray = weightArray + (learningRate * gapBetweenClasses)...
                                            * transpose(featureVectorArray{i});
            end
        end
        
        % ��������
        % �S�Ă̊w�K�f�[�^�����������ނł���ΏI������.
        % ���`�����\�ȃf�[�^����������, �L����̌J��Ԃ��Ō������Ɏ�������͂�.
        if nSolve == size(featureVectorArray,2)
            break
        end
        
        % �����ł��Ȃ������ꍇ�͌x����, �I������.
        if l == nLoop
            fprintf(2,'error : �����ł��܂���ł���.\n');
            return
        end
        
        nSolve = 0;
    end
    
    %-------------
    % ���ʂ��v���b�g
    %-------------
    plotPerceptron(weightArray, featureVectorArray);
end

% �P���p�[�Z�v�g�����̃v���b�g
function plotPerceptron(weightArray, sampleDataArray)
    %-------------
    % ���ʋ��E�̕`��
    %-------------
    % ���E�ƂȂ钼���̕������𕶎���ō쐬����.
    border = strcat(num2str(weightArray(1)), ' * t_', num2str(1));
    for i=2:1:size(weightArray,1)
        if i ~= size(weightArray,1)
            border = ...
                strcat(border, ' + ', num2str(weightArray(i)),...
                                                    ' * t_', num2str(i));
        else
            border = ...
                strcat(border, ' + ', num2str(weightArray(i)));
        end
    end
    hBorder = ezplot(border);
    set(hBorder, 'LineColor', 'b');
    
    %----------------------
    % �e�T���v���f�[�^�̃v���b�g
    %----------------------
    hold on
    for i=1:1:size(sampleDataArray,2)
        % �N���X���v�Z����.
        calculatedClass = ...
            activationFunction(sampleDataArray{i}, weightArray);
        % �v�Z�����N���X���Ƀv���b�g����.
        switch calculatedClass
            case 0
                plot(sampleDataArray{i}(1),sampleDataArray{i}(2),'bo',...
                'MarkerSize',10,...
                'MarkerFaceColor','k');
            case 1
                plot(sampleDataArray{i}(1),sampleDataArray{i}(2),'ro',...
                'MarkerSize',10,...
                'MarkerFaceColor','r'); 
        end
    end
    hold off
end

% �������֐�
% 0�ȏ�Ȃ�1, 0�����Ȃ�, 0��Ԃ�.
function class = activationFunction(inputArray, weightArray)
    sumOfInputArray = inputArray * weightArray;
    if sumOfInputArray >= 0
        class = 1;
    else
        class = 0;
    end 
end