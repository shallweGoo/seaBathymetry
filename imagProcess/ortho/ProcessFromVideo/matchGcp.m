function [outputArg1,outputArg2] = matchGcp(gcpInfo,cmPara,mode)
%calcRotateMatrix ���ݵ�һ֡�Ŀ��Ƶ���ƥ�������֡�Ŀ��Ƶ�
%

% �����������
% gcpInfo����������ϢgcpInfo(1)Ϊgcp��uv�е����꣬gcpInfo(2)Ϊgcp���Զ�������ϵ�µ�����
    
% cmParaΪ�������
    

% ***modeΪ����õ�ÿ֡gcpƥ��ģʽ
% ***mode1Ϊ CRIN ����ֵƥ�䣬��������ϣ��Ż����õ����
% ***mode2Ϊ �Լ�����ģ��ƥ��

    if nargin < 2
        %Ĭ��ΪCRIN��ֵƥ��
        mode = 1;
    end
    
    switch mode
        case 1
            
        
        
        case 2
        
                    
        
        otherwise
            error("happened confliction because unsituable mode");
            
            
    end
    



end

