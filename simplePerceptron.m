% 二次元空間に対する単純パーセプトロン
function simplePerceptron(dataFile)
    %-------------
    % データ読み込み
    %-------------
    % 形式は, 各行が [x座標, y座標, クラス] であるCSVファイル.
    % クラスは, 0 もしくは 1 の2種類にのみ対応.
    data = csvread(dataFile);
    nCol = size(data,1);
    % 学習データを読み込む.
    learningDataArray = cell(1,nCol);
    for i=1:1:nCol
        learningDataArray{i} = [data(i,1), data(i,2)];
    end
    % 各学習データに対応したクラスを読み込む.
    expectedClassArray = data(:,3);
    
    %-------------
    % 各データ初期化
    %-------------
    % 最大ループ回数
    nLoop = 100000;
    % 正答数
    nSolve = 0;
    % 重みの初期値. ランダムに設定する.
    weightArray = randi([-1,1], 2+1, 1);
    % 学習率
    learningRate = 0.5;
    % サンプルデータを特微ベクトルへ変換する.
    featureVectorArray = cell(1, size(learningDataArray,2));
    for i=1:1:size(learningDataArray,2)
        featureVectorArray{i} = [learningDataArray{i} 1];
    end
    
    %-------------
    % 学習部分
    %-------------
    for l=1:1:nLoop
        % 学習データ全てに, 識別関数を適用する.
        for i=1:1:size(featureVectorArray, 2)
            % 1つの学習データを, 識別関数に適用する.
            calculatedClass = ...
                activationFunction(featureVectorArray{i},weightArray);
            
            if expectedClassArray(i) == calculatedClass
                % 正しいクラスであれば, 記録する.
                nSolve = nSolve + 1;
            else
                % 正しくないクラスであれば, 記録しない.
                % 　期待されていたクラスと実際に出力されたクラスの差分をとり,
                % 　重みを更新する.
                gapBetweenClasses = expectedClassArray(i)-calculatedClass;
                weightArray = weightArray + (learningRate * gapBetweenClasses)...
                                            * transpose(featureVectorArray{i});
            end
        end
        
        % 収束判定
        % 全ての学習データが正しく分類できれば終了する.
        % 線形分離可能なデータを扱うため, 有限回の繰り返しで厳密解に収束するはず.
        if nSolve == size(featureVectorArray,2)
            break
        end
        
        % 発見できなかった場合は警告し, 終了する.
        if l == nLoop
            fprintf(2,'error : 分離できませんでした.\n');
            return
        end
        
        nSolve = 0;
    end
    
    %-------------
    % 結果をプロット
    %-------------
    plotPerceptron(weightArray, featureVectorArray);
end

% 単純パーセプトロンのプロット
function plotPerceptron(weightArray, sampleDataArray)
    %-------------
    % 識別境界の描画
    %-------------
    % 境界となる直線の方程式を文字列で作成する.
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
    % 各サンプルデータのプロット
    %----------------------
    hold on
    for i=1:1:size(sampleDataArray,2)
        % クラスを計算する.
        calculatedClass = ...
            activationFunction(sampleDataArray{i}, weightArray);
        % 計算したクラス毎にプロットする.
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

% 活性化関数
% 0以上なら1, 0未満なら, 0を返す.
function class = activationFunction(inputArray, weightArray)
    sumOfInputArray = inputArray * weightArray;
    if sumOfInputArray >= 0
        class = 1;
    else
        class = 0;
    end 
end