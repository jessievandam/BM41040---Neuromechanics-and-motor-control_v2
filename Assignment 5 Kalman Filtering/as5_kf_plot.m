function as5_kf_plot(input,params,data,WhatamI)
% Written by : Alexander Kuck
% Date       : February 20 2017


switch WhatamI
    case 'Kalman'
        t=(1:length(input.yHand))*0.01;
        FigHandle=figure;
        pos=get(FigHandle,'Position');
        set(FigHandle, 'Position', [100, 100, pos(3)*3, pos(4)*2]);
        subplot(2,3,1); hold on; title('Position [m]')
        plot(t,input.yNoise(:,1),'Color',[.8 .8 .8])
        plot(t,input.yHand(:,1),'b')
        plot(t,input.xPosterioArray(:,1),'r','LineWidth',2)
        xlabel('time [s]')

        subplot(2,3,4); hold on; title('Velocity [m/s]')
        plot(t,input.yNoise(:,2),'Color',[.8 .8 .8])
        plot(t,input.yHand(:,2),'b')
        plot(t,input.xPosterioArray(:,2),'r','LineWidth',2)
        xlabel('time [s]')
        legend([{'Sensory Feedback'},{'True Hand'},{'Posteriori State Estimate'}],'location','northeast');
        
        subplot(2,3,[2 5]); hold on; title('Kalman Gains')
        plot(t,input.MArray(:,1,1),'r')
        plot(t,input.MArray(:,2,1),'g')
        plot(t,input.MArray(:,1,2),'--b')
        plot(t,input.MArray(:,2,2),'k')
        xlabel('time [s]')
        legend([{'M(1,1)'},{'M(2,1)'},{'M(1,2)'},{'M(2,2)'}],'location','southeast');

        subplot(2,3,[3 6]); hold on; title('Covariance Matrices')
        plot(t,input.pPosterioArray(:,1,1),'r')
        plot(t,input.pPosterioArray(:,2,1),'g')
        plot(t,input.pPosterioArray(:,1,2),'--b')
        plot(t,input.pPosterioArray(:,2,2),'k')
        xlabel('time [s]')
        legend([{'P(1,1)'},{'P(2,1)'},{'P(1,2)'},{'P(2,2)'}],'location','southeast');
        
    case 'Movement'
        t=(1:length(data.u))*0.01;
        FigHandle = figure;
        pos=get(FigHandle,'Position');
        set(FigHandle, 'Position', [100, 100, pos(3)*1, pos(4)*1.5]);
        subplot(3,1,1)
        plot(t,data.u)
        ylabel('Input [N]')
        ylim([-1.75 1.75])
        xlim([0 params.t(end)])
        title('Dynamic Model Input and Outputs')
        
        subplot(3,1,2); hold on;
        plot(t,input.yNoise(:,1),'Color',[.8 .8 .8])
        plot(t,input.yForward(:,1),'r')
        plot(t,input.yHand(:,1),'k')
        ylabel('Position [m]')
        xlim([0 params.t(end)])
        legend([{'True Hand Model with Noise'}, {'Forward Model'},{'True Hand without Noise'}],'location','southeast');
        ylim([-0.1 0.3])
        
        subplot(3,1,3); hold on;
        plot(t,input.yNoise(:,2),'Color',[.8 .8 .8])
        plot(t,input.yForward(:,2),'r')
        plot(t,input.yHand(:,2),'k')
        ylabel('Velocity [m/s]')
        xlabel('Time[s]')
        xlim([0 params.t(end)])
        ylim([-0.1 0.3])
        
        
     case 'MovementDelayed'
        t=(1:length(data.u))*0.01;
        FigHandle=figure;
        pos=get(FigHandle,'Position');
        set(FigHandle, 'Position', [100, 100, pos(3)*1, pos(4)*1.5]);
        subplot(3,1,1)
        plot(t,data.u)
        ylabel('Input [N]')
        ylim([-1.75 1.75])
        xlim([0 params.t(end)])
        title('Delayed Model Input and Outputs')
        
        subplot(3,1,2); hold on;
        plot(t,input.yNoiseDelayed(:,1),'Color',[.8 .8 .8])
        plot(t,input.yHand(:,1),'k--')
        plot(t,input.yForwardDelayed(:,1),'r')
        plot(t,input.yHandDelayed(:,1),'k')
        ylabel('Position [m]')
        xlim([0 params.t(end)])
        ylim([-0.1 0.3])
        legend([{'True Hand with Noise Delayed'},{'True Hand (No Noise) Undelayed'},{'Forward Model Delayed'},{'True Hand Model Delayed'}],'location','southeast');
        
        subplot(3,1,3); hold on;
        plot(t,input.yNoiseDelayed(:,2),'Color',[.8 .8 .8])
        plot(t,input.yHand(:,2),'k--')
        plot(t,input.yForwardDelayed(:,2),'r')
        plot(t,input.yHandDelayed(:,2),'k')
        ylabel('Velocity [m/s]')
        xlabel('Time[s]')
        xlim([0 params.t(end)])
        ylim([-0.1 0.3])
        
    case 'Compare'
        t=(1:length(input.yHand{1}))*0.01;
        coloring=winter(length(input.yNoise));
        ax=[];
        labels=cell(1,length(input.levels));
        for i=1:length(input.levels)
            labels{i}=[num2str(input.levels(i)) ' ' input.varied];
        end
        
        FigHandle=figure;
        pos=get(FigHandle,'Position');
        set(FigHandle, 'Position', [100, 100, pos(3)*3, pos(4)*2]);
        ax(1)=subplot(2,6,[1 2]); hold on; title('Dashed Line = True Hand, Solid Line = Posteriori State Estimate', 'FontSize', 10)
        leg_obj{1}=zeros(1,length(input.yNoise));
        leg_obj{2}=zeros(1,length(input.yNoise));
        for i=1:length(input.yNoise)
%             temp=Input.yHand{i}(:,1)-Input.xPosterioArray{i}(:,1);
%             plot(t,temp,'Color',coloring(i,:))
%             plot(t,Input.yNoise{i}(:,1),'--','Color',coloring(i,:))
            leg_obj{1}(i)=plot(t,input.yHand{i}(:,1),'--','Color',coloring(i,:));
            leg_obj{2}(i)=plot(t,input.xPosterioArray{i}(:,1),'Color',coloring(i,:),'LineWidth',2);
        end
        xlabel('time [s]')
        ylabel('Position [m]')
        legend(leg_obj{2},labels,'location','southeast');
        
%         text(0.2,0.2,'Real Hand Movement Kalman Estimate')
        ax(2)=subplot(2,6,[7 8]); hold on; 
        for i=1:length(input.yNoise)
%             temp=Input.yHand{i}(:,2)-Input.xPosterioArray{i}(:,2);
%             plot(t,(temp),'Color',coloring(i,:))
%             plot(t,Input.yNoise{i}(:,2),'Color',coloring(i,:))
            plot(t,input.yHand{i}(:,2),'--','Color',coloring(i,:))
            plot(t,input.xPosterioArray{i}(:,2),'Color',coloring(i,:),'LineWidth',2)
        end
        ylabel('Velocity [m/s]')
        xlabel('time [s]')
        
        
        ax(3)=subplot(2,6,3); hold on; title('M(1,1)')
        for i=1:length(input.yNoise)
            plot(t,input.MArray{i}(:,1,1),'Color',coloring(i,:))
        end
        xlabel('time [s]')
        
        ax(4)=subplot(2,6,4); hold on; title('M(1,2)')
        for i=1:length(input.yNoise)
            plot(t,input.MArray{i}(:,1,2),'Color',coloring(i,:))
        end
        xlabel('time [s]')
        
        ax(5)=subplot(2,6,9); hold on;  title('M(2,1)')
        for i=1:length(input.yNoise)
            plot(t,input.MArray{i}(:,2,1),'Color',coloring(i,:))
        end
        xlabel('time [s]')
        
        ax(6)=subplot(2,6,10); hold on; title('M(2,2)')
        for i=1:length(input.yNoise)
            plot(t,input.MArray{i}(:,2,2),'Color',coloring(i,:))
        end
        xlabel('time [s]')

        ax(7)=subplot(2,6,5); hold on; title('P(1,1)')
        for i=1:length(input.yNoise)
            plot(t,input.pPosterioArray{i}(:,1,1),'Color',coloring(i,:))
        end
        xlabel('time [s]')
        
        ax(8)=subplot(2,6,6); hold on; title('P(1,2)')
        for i=1:length(input.yNoise)
            plot(t,input.pPosterioArray{i}(:,2,1),'Color',coloring(i,:))
        end
        xlabel('time [s]')
        
        ax(9)=subplot(2,6,11); hold on; title('P(2,1)')
        for i=1:length(input.yNoise)
            plot(t,input.pPosterioArray{i}(:,1,2),'Color',coloring(i,:))
        end
        xlabel('time [s]')
        
        ax(10)=subplot(2,6,12); hold on;  title('P(2,2)')
        for i=1:length(input.yNoise)
            plot(t,input.pPosterioArray{i}(:,2,2),'Color',coloring(i,:))
        end
        xlabel('time [s]')
        
        for i=1:length(ax)
            xlim(ax(i),[t(1) t(end)])
        end
end
end