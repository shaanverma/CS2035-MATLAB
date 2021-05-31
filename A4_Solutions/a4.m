%% Assignment 4: London Weather Data Analysis
%
% Robert Moir: 0123456789

%% Input Data
clear
ylabels = {'Year','Month','Mean Max Temp (°C)','Mean Min Temp (°C)',...
    'Mean Temp (°C)','Extr Max Temp (°C)','Extr Min Temp (°C)',...
    'Total Rain (mm)','Total Snow (cm)','Total Precip (mm)'};
titles = {'Year','Month','Mean Maximum Temperature (°C)',...
    'Mean Minimum Temperature (°C)','Mean Temperature (°C)',...
    'Extreme Maximum Temp (°C)','Extreme Minimum Temp (°C)',...
    'Total Rain (mm)','Total Snow (cm)','Total Precipitation (mm)'};

D1 = csvread('London_South_Monthly_1883-1932.csv',19,1);
D2 = csvread('London_Lambeth_A_Monthly_1930-1941.csv',19,1);
D3 = csvread('London_Intl_Airport_Monthly_1940-2006.csv',19,1);
D = [D1(3:end-8,:); D2(29:end-17,:); D3(8:end-50,:)];

%% Plot Data

x = D(:,1)+(D(:,2)-1)/12;
for n=3:10
    figure
    plot(x,D(:,n))
    xlabel('Year')
    ylabel(ylabels(n))
    title(strcat('London Ontario', " ", titles(n)))
    axis tight
    set(gcf,'Position',[100 100 800 400])
    print(strcat("London ",ylabels(n),".png"),'-dpng')
end

%% Clear Figure Data
close all

%% Analyze Data

% Compute the number of days per month over a four year period
% Page 1: Spring
days(:,:,1)=[31*ones(4,1) 30*ones(4,1) 31*ones(4,1)];
% Page 2: Summer
days(:,:,2)=[30*ones(4,1) 31*ones(4,1) 31*ones(4,1)];
% Page 3: Fall
days(:,:,3)=[30*ones(4,1) 31*ones(4,1) 30*ones(4,1)];
% Page 4: Winter
days(:,:,4)=[31*ones(4,1) 31*ones(4,1) 28*ones(4,1)];
days(2,3,4)=29;
season = {'Spring','Summer','Fall','Winter'};
% Starting row for each season
row = [1 4 7 10];
for j=1:4
    % Compute the number of years for the current season (given by j)
    n_years = floor(size(D,1)/12);
    if (rem(size(D,1),12) >= row(j)+2)
        n_years = n_years+1;
    end
    fprintf(strcat('\n',season(j)," ",'Season Data Analysis:\n'));
    for n=3:10
        % compute first element of the years and data vectors
        years = D(1,1);
        if 3<=n && n<=5
            data = (D(row(j),n)*days(1,1,j) + D(row(j)+1,n)*days(1,2,j) +...
                D(row(j)+2,n)*days(1,3,j))/(sum(days(1,1:3,j)));
        elseif n==6
            data = max(D(row(j):row(j)+2,n));
        elseif n==7
            data = min(D(row(j):row(j)+2,n));
        elseif 8<=n && n<=10
            data = sum(D(row(j):row(j)+2,n));
        end
        % loop to compute the rest of years and data vectors
        for i=2:n_years-1
            % compute the row numbers of the first and last month of
            % the current season
            first_element = row(j)+i*12;
            last_element = row(j)+2+i*12;
            % collect the data values for the current season and the
            % current data field (given by n)
            yrdata = D(first_element:last_element,n);
            % check to see if there are any NaN values in the data
            % to determine whether a valid seasonal value can be computed
            if (~any(isnan(yrdata)))
                % add the current year to years vector
                years(end+1,1) = D(first_element,1);
                % add the the seasonal data value to the data vector
                % check for mean calculation
                if 3<=n && n<=5
                    k = mod(i,4)+1;
                    % compute a weighted average of the monthly data
                    % given the lengths of the months in the given season
                    data(end+1,1) = (yrdata(1)*days(k,1) +...
                        yrdata(2)*days(k,2,j) + yrdata(3)*days(k,3,j))/...
                        (sum(days(k,1:3,j)));
                % check for max calculation
                elseif n==6
                    data(end+1,1) = max(yrdata);
                % check for min calculation
                elseif n==7
                    data(end+1,1) = min(yrdata);
                % check for total calculation
                elseif 8<=n && n<=10
                    data(end+1,1) = sum(yrdata);
                end
            end
        end
        %years = years(70:end);
        %data = data(70:end);
        % compute the linear regression of the seasonal data for the
        % current data field
        [b, bint] = regress(data,[ones(size(years)) years],0.3173);
        % check whether the slope is exactly zero (indicating void data)
        if (b(2) ~= 0)
            figure
            plot(years,data)
            axis tight
            hold on
            xlabel('Year')
            ylabel(ylabels(n))
            % label the plot with the current season and data field
            title(strcat('London Ontario', " ", season(j)," ", titles(n)))
            plot(years,b(2)*years+b(1),'LineWidth',2)
            hold off
            % label the output file with the current season and data field
            print(strcat("London ",season(j)," Trend ",ylabels(n),".png"),'-dpng')
            % check whether the slope is positive or negative and
            % display an appropriate message
            if (b(2)>0)
                disp(strcat('Potential increasing trend for'," ",titles(n),':'))
            elseif (b(2)<0)
                disp(strcat('Potential decreasing trend for'," ",titles(n),':'))
            end
            % check that the confidence interval does not contain zero
            if (sign(bint(2,1)) == sign(bint(2,2)))
                disp('  Significant trend at 68% confidence!')
                % compute standard deviation
                sigma = abs(b(2) - bint(2,1));
                fprintf('  Trend is %f +/- %f ',b(2)*100,sigma*100);
                % check for units of °C
                if 3<=n && n<=7
                    fprintf('°C/century\n');
                % check for units of mm
                elseif n==8 || n==10
                    fprintf('mm/century\n');
                % check for units of cm
                elseif n==9
                    fprintf('cm/century\n');
                end
                % check whether 2*sigma interval contains zero
                if (sign(bint(2,1)-sigma) == sign(bint(2,2)+sigma))
                    disp('  Significant trend at 95% confidence too!')
                end
            else
                disp('  Trend is not statistically significant')
            end
        end
    end
end

%% Discussion of Results
%
% Spring Season:
%
% Quantities showing a decreasing trend: Mean Max T, Extr Max T, Total
% Snow.
%
% Quantities showing an increasing trend: Mean Min T, Mean T, Extr Min T,
% Total Rain, Total Precip.
%
% Statistically significant tends at 68% confidence: Mean Min T, Extr Max,
% Extr Min T and Total Rain
%
% Taken together, we see the maximum temperature decreasing, the minimum
% temperature increasing, with a very small increase in overall
% temperature, together with a decrease in snow and an increase in rain.
% Yes, these trends are consistent. Together they suggest a minimal warming 
% over spring while the temperature variation is becoming less extreme (max
% decrease, min increase). Only the min increase has a reasonably strong 
% statistical significance.
%
%
% Summer Season:
%
% Quantities showing a decreasing trend: Mean Max T, Mean T, Extr Max T.
%
% Quantities showing an increasing trend: Mean Min T, Extr Min T, Total
% Rain, Total Precip
%
% Statistically significant trends at 68% confidence: Mean Max T, Mean Min
% T, Extr Max T, Extr Min T.
%
% Taken together, we see the maximum temperature decreasing, the minimum
% temperature increasing, with a very small decrease in overall
% temperature, together with an increase in rain. Yes, these trends are 
% consistent. Together they suggest a minimal cooling over summer while the 
% temperature variation is becoming less extreme (max decrease, min 
% increase). In this case the max decrease and min increase for both mean 
% and extreme values is reasonably statistically significant, with the
% minimum increases significant also at 99%, lending greater credence to the
% hypothesis that weather in London is becoming less extreme.
%
% Fall Season:
%
% Quantities showing a decreasing trend: Mean Max T, Extr Max T, Total Snow
%
% Quantities showing an increasing trend: Mean Min T, Mean T, Extr Min T,
% Total Rain, Total Precip
%
% Statistically significant trends at 68% confidence: Mean Max T, 
% Mean Min T, Extr Max T, Extr Max, Extr Min T, Total Rain, Total Snow,
% Total Precip
%
% Taken together we see the maximum temperature decreasing, the minimum
% temperature increase, with a very small increase in overall temperature,
% together with a decrease in snow and an increase in rain and total
% precipitation. with all of these trends being roughly statistically
% significant. Once again, these are consistent. Taken together they 
% suggest a minimal warming over the fall season with the overall 
% temperature variation becoming less extreme. There is evidence of an
% increase in rain in the fall, with the rain contributing to an increase 
% in precipitation.
%
% Winter Season:
%
% Quantities showing a decreasing trend: Mean Max T, Total Rain, Total
% Snow, Total Precip.
%
% Quantities showing an increasing trend: Mean Min T, Mean T, Extr Max T,
% Extr Min T.
%
% Statistically significant trends at 68% confidence: Mean Min T, 
% Extr Max T, Extr Min T, Total Snow, Total Precip.
%
% Taken together we see the maximum temperature decreasing, the minimum and
% overal temperature increasing, with a slight increase in extreme high
% temperatures, together with a decrease of rain and snow. These trends are
% certainly consistent too. Taken together they suggest a minimal warming
% over the winter season, with the overall temperature variation becoming
% less extreme, together with an overall decrease in both kinds of
% preciptiation.
%
% 95% Confidence Trends:
%
% The trends that are significant at 95% confidence are the following:
% Spring: Mean Min T, Extr Min T
% Summer: Mean Max T, Mean Min T, Extr Max T, Extr Min T
% Fall: Mean Min T, Extr Max T, Total Rain, Total Precip
% Winter: Extr Min, Total Precip
%
% Everyone should find:
% (1) extreme min temperature in the Spring, Summer and Winter;
% (2) extreme max temperature in the Summer and Fall.
%
% Only some will find (depending on what variables you computed):
% (3) mean min temperature in Spring, Summer and Fall;
% (4) mean max temperature in Summer;
% (5) total rain in Fall;
% (6) total precipitation in Winter.
%
% Some other quantities are close to being 95% significant, but it is not
% necessary to identify these.
%
% The extreme min increases and max decreases, which everyone should find,
% are of certainly consistent, indicating less extreme temperature
% variations. This hypothesis is corroborated by the mean min increases and
% mean max increases among the Spring, Summer and Fall seasons. Thus, there
% is decent evidence that (over the 1883-2001) period, the weather in
% London became less extreme.
%
% The increase in rain and precipitation are also consistent, suggesting
% that the Fall and Winter seasons are becoming wetter. Any judgement of
% the reason for this is not supported by the data.
%
% Overall Conclusion:
%
% Overall the results support the conclusion that the weather in London has
% become less extreme over the last 100 years, though a more careful
% analysis would be needed to establish this, including looking for
% corroborating evidence from other weather stations and seeing how strong
% the effect is when yearly averages are computed.

close all