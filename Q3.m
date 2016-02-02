load('Data.mat')
CommercialAMRS = [];
IndustrialAMRS = [];
ResidentialAMRS = [];
TransportationAMRS = [];
TotalAMRS = [];
CommercialDemand = [];
IndustrialDemand = [];
ResidentialDemand = [];
TransportationDemand = [];
TotalAMRS = [];
for idx = 1:size(UtilityNumberSaving,1)
    
    AMR_IDX = UtilityNumberAMR == UtilityNumberSaving(idx);
    Demand_IDX = UtilityNumber_Demand == UtilityNumberSaving(idx);
    
    if sum(AMR_IDX) > 1
        AMR_State = strcmp(StateAMR , StateSaving(idx));
        AMR_IDX2 = logical(AMR_IDX.*AMR_State);
        if sum(AMR_IDX2)~= 0
            ResidentialAMRS = [ResidentialAMRS; [Residential_AMR(AMR_IDX2), Residential_AMI(AMR_IDX2)]];
            CommercialAMRS = [CommercialAMRS; [Commercial_AMR(AMR_IDX2), Commercial_AMI(AMR_IDX2)]];
            IndustrialAMRS = [IndustrialAMRS; [Industrial_AMR(AMR_IDX2), Industrial_AMI(AMR_IDX2)]];
            TransportationAMRS = [TransportationAMRS; [Transportation_AMR(AMR_IDX2), Transportation_AMI(AMR_IDX2)]];
        else
            ResidentialAMRS = [ResidentialAMRS; [NaN, NaN]];
            CommercialAMRS = [CommercialAMRS; [NaN, NaN]];
            IndustrialAMRS = [IndustrialAMRS; [NaN, NaN]];
            TransportationAMRS = [TransportationAMRS; [NaN, NaN]];
        end
    elseif sum(AMR_IDX) == 0
        ResidentialAMRS = [ResidentialAMRS; [NaN, NaN]];
        CommercialAMRS = [CommercialAMRS; [NaN, NaN]];
        IndustrialAMRS = [IndustrialAMRS; [NaN, NaN]];
        TransportationAMRS = [TransportationAMRS; [NaN, NaN]];
    else
        ResidentialAMRS = [ResidentialAMRS; [Residential_AMR(AMR_IDX), Residential_AMI(AMR_IDX)]];
        CommercialAMRS = [CommercialAMRS; [Commercial_AMR(AMR_IDX), Commercial_AMI(AMR_IDX)]];
        IndustrialAMRS = [IndustrialAMRS; [Industrial_AMR(AMR_IDX), Industrial_AMI(AMR_IDX)]];
        TransportationAMRS = [TransportationAMRS; [Transportation_AMR(AMR_IDX), Transportation_AMI(AMR_IDX)]];
    end
    
    if sum(Demand_IDX) > 1
        Demand_State = strcmp(State_Demand , StateSaving(idx));
        Demand_IDX2 = logical(Demand_IDX.*Demand_State);
        
        if sum(Demand_IDX2)~= 0
            
            ResidentialDemand = [ResidentialDemand; [Residential_Demand(Demand_IDX2), Residential_AMI(Demand_IDX2)]];
            CommercialDemand = [CommercialDemand; [Commercial_AMR(Demand_IDX2), Commercial_AMI(Demand_IDX2)]];
            IndustrialDemand= [IndustrialDemand; [Industrial_AMR(Demand_IDX2), Industrial_AMI(Demand_IDX2)]];
            TransportationDemand = [TransportationDemand; [Transportation_AMR(Demand_IDX2), Transportation_AMI(Demand_IDX2)]];
        else
            ResidentialDemand = [ResidentialDemand; [NaN, NaN]];
            CommercialDemand = [CommercialDemand; [NaN, NaN]];
            IndustrialDemand = [IndustrialDemand; [NaN, NaN]];
            TransportationDemand = [TransportationDemand; [NaN, NaN]];
        end
        
    elseif sum(Demand_IDX) == 0
        ResidentialDemand = [ResidentialDemand; [NaN, NaN]];
        CommercialDemand = [CommercialDemand; [NaN, NaN]];
        IndustrialDemand = [IndustrialDemand; [NaN, NaN]];
        TransportationDemand = [TransportationDemand; [NaN, NaN]];
    else
        ResidentialDemand = [ResidentialDemand; [Residential_AMR(Demand_IDX), Residential_AMI(Demand_IDX)]];
        CommercialDemand = [CommercialDemand; [Commercial_AMR(Demand_IDX), Commercial_AMI(Demand_IDX)]];
        IndustrialDemand = [IndustrialDemand; [Industrial_AMR(Demand_IDX), Industrial_AMI(Demand_IDX)]];
        TransportationDemand = [TransportationDemand; [Transportation_AMR(Demand_IDX), Transportation_AMI(Demand_IDX)]];
    end
    
    if idx~= size(ResidentialDemand,1)
        keyboard;
    end
end

% RESIDENTIAL SECTOR
% Y = quantile
% residential plots
figure;
subplot(2,2,1)
plot(ResidentialAMRS(:,1), Residential_Saving, 'o')
xlabel('AMR');
ylabel('Savings');

%removing nans
ResidentialAMRS_new = [];
Residential_Saving_new = [];
for ivx = 1:size(Residential_Saving,1)
    if ~isnan(Residential_Saving(ivx,1)) && ~isnan(ResidentialAMRS(ivx,1))
        ResidentialAMRS_new = [ResidentialAMRS_new;ResidentialAMRS(ivx,1)] ;
        Residential_Saving_new = [Residential_Saving_new;Residential_Saving(ivx,1)];
    end
end
fitResults = fit(ResidentialAMRS_new,Residential_Saving_new,'poly1');
plot(fitResults,ResidentialAMRS_new,Residential_Saving_new)
xlabel('Automatic Meter Readers Installed');
ylabel('Total Energy Savings (MW)');
print('AMR-S.png', '-dpng', '-r300')

subplot(2,2,2)
plot(ResidentialAMRS(:,2), Residential_Saving, 'o')
xlabel('AMI');
ylabel('Savings');


subplot(2,2,3)
plot(ResidentialAMRS(:,2), Residential_PeakSaving, 'o')
xlabel('AMI');
ylabel('Peak Savings');

subplot(2,2,4)
plot(ResidentialAMRS(:,1), Residential_PeakSaving, 'o')
xlabel('AMR');
ylabel('Peak Savings');

% normality test
[h1,p1] = kstest2(ResidentialAMRS(:,1), Residential_PeakSaving);
[h2,p2] = kstest2(ResidentialAMRS(:,2), Residential_PeakSaving);
[h3,p3] = kstest2(ResidentialAMRS(:,1), Residential_Saving);
[h4,p4] = kstest2(ResidentialAMRS(:,2), Residential_Saving);
[h4,p4] = kstest2(ResidentialDemand(:,1), Residential_PeakSaving);

% t-test to evaluate potential correlation
[R1,P1,RL1,RU1]  = corrcoef(ResidentialAMRS(:,1), Residential_PeakSaving, 'rows','pairwise');
[R2,P2,RL2,RU2]  = corrcoef(ResidentialAMRS(:,2), Residential_PeakSaving, 'rows','pairwise');
[R3,P3,RL3,RU3]  = corrcoef(ResidentialAMRS(:,1), Residential_Saving, 'rows','pairwise');
[R4,P4,RL4,RU4]  = corrcoef(ResidentialAMRS(:,2), Residential_Saving, 'rows','pairwise');
[R5,P5,RL5,RU5]  = corrcoef(ResidentialDemand(:,1), Residential_PeakSaving, 'rows','pairwise');
[R6,P6,RL6,RU6]  = corrcoef(ResidentialDemand(:,1), Residential_Saving, 'rows','pairwise');

% Peak savings and demand response nerollement has a negative correlation
% (This does not make sense) --> Further analysis required

figure;
plot(ResidentialDemand(:,1), Residential_PeakSaving, 'o')
xlabel('Demand Response Customers Enrolled');
ylabel('Peak Savings');

% outlier detection
[i,j] = max(ResidentialDemand(:,1));
ResidentialDemand(j,:) = [NaN NaN];

[i,j] = max(Residential_PeakSaving(:,1));
Residential_PeakSaving(j,1) = [NaN];

% replotting
figure;
plot(ResidentialDemand(:,1), Residential_PeakSaving, 'o')
xlabel('Demand Response Customers Enrolled');
ylabel('Peak Savings');

% fitting 

%removing nans
ResidentialDemand_new = [];
ResidentialPeakSaving_new = [];
for ivx = 1:size(ResidentialDemand,1)
    if ~isnan(ResidentialDemand(ivx,1)) && ~isnan(Residential_PeakSaving(ivx,1))
        ResidentialDemand_new = [ResidentialDemand_new;ResidentialDemand(ivx,1)] ;
        ResidentialPeakSaving_new = [ResidentialPeakSaving_new;Residential_PeakSaving(ivx,1)];
    end
end
fitResults = fit(ResidentialDemand_new,ResidentialPeakSaving_new,'poly1');
plot(fitResults,ResidentialDemand_new,ResidentialPeakSaving_new)

% boxplot
[B, Ix] = sort(ResidentialDemand);
B2 = Residential_PeakSaving(Ix);
Breshape = reshape(B2(:,1), 71,10);
Bquantile = quantile(B(:,1), [0:.1:1]);
boxplot(Breshape)
xlabel('Demand Response Customers Enrolled');
ylabel('Peak Savings (MW)');
print('DR-PS.png', '-dpng', '-r300')
%COMMERCIAL PLOTS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Commercial plots

figure;
subplot(2,2,1)
plot(CommercialAMRS(:,1), Commercial_Saving, 'o')
xlabel('AMRS');
ylabel('Savings');
xlabel('AMR');
ylabel('Peak Savings');

subplot(2,2,2)
plot(CommercialAMRS(:,2), Commercial_Saving, 'o')
xlabel('AMI');
ylabel('Savings');


subplot(2,2,3)
plot(CommercialAMRS(:,2), Commercial_PeakSaving, 'o')
xlabel('AMI');
ylabel('Peak Savings');

subplot(2,2,4)
plot(CommercialAMRS(:,1), Commercial_PeakSaving, 'o')
xlabel('AMR');
ylabel('Peak Savings');

% normality test
[h1,p1] = kstest2(CommercialAMRS(:,1), Commercial_PeakSaving);
[h2,p2] = kstest2(CommercialAMRS(:,2), Commercial_PeakSaving);
[h3,p3] = kstest2(CommercialAMRS(:,1), Commercial_Saving);
[h4,p4] = kstest2(CommercialAMRS(:,2), Commercial_Saving);

% t-test to evaluate potential correlation
[R1,P1,RL1,RU1]  = corrcoef(CommercialAMRS(:,1), Commercial_PeakSaving, 'rows','pairwise');
[R2,P2,RL2,RU2]  = corrcoef(CommercialAMRS(:,2), Commercial_PeakSaving, 'rows','pairwise');
[R3,P3,RL3,RU3]  = corrcoef(CommercialAMRS(:,1), Commercial_Saving, 'rows','pairwise');
[R4,P4,RL4,RU4]  = corrcoef(CommercialAMRS(:,2), Commercial_Saving, 'rows','pairwise');

%INDUSTRIAL PLOTS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Industrial plots

figure;
subplot(2,2,1)
plot(IndustrialAMRS(:,1), Industrial_Saving, 'o')
xlabel('AMRS');
ylabel('Savings');
xlabel('AMR');
ylabel('Peak Savings');

subplot(2,2,2)
plot(IndustrialAMRS(:,2), Industrial_Saving, 'o')
xlabel('AMI');
ylabel('Savings');


subplot(2,2,3)
plot(IndustrialAMRS(:,2), Industrial_PeakSaving, 'o')
xlabel('AMI');
ylabel('Peak Savings');

subplot(2,2,4)
plot(IndustrialAMRS(:,1), Industrial_PeakSaving, 'o')
xlabel('AMR');
ylabel('Peak Savings');

% normality test
[h1,p1] = kstest2(IndustrialAMRS(:,1), Industrial_PeakSaving);
[h2,p2] = kstest2(IndustrialAMRS(:,2), Industrial_PeakSaving);
[h3,p3] = kstest2(IndustrialAMRS(:,1), Industrial_Saving);
[h4,p4] = kstest2(IndustrialAMRS(:,2), Industrial_Saving);

% t-test to evaluate potential correlation
[R1,P1,RL1,RU1]  = corrcoef(IndustrialAMRS(:,1), Industrial_PeakSaving, 'rows','pairwise');
[R2,P2,RL2,RU2]  = corrcoef(IndustrialAMRS(:,2), Industrial_PeakSaving, 'rows','pairwise');
[R3,P3,RL3,RU3]  = corrcoef(IndustrialAMRS(:,1), Industrial_Saving, 'rows','pairwise');
[R4,P4,RL4,RU4]  = corrcoef(IndustrialAMRS(:,2), Industrial_Saving, 'rows','pairwise');
