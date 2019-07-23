function member = evalMfTypeHelper( type,input,mfParams )
switch type
    case 'gaussmf'
         member =helper.gaussmf(input, mfParams);
    case 'zmf'
         member =helper.zmf(input, mfParams);
    case 'trapmf'
         member =helper.trapmf(input, mfParams);
     case 'trimf'
        member =helper.trimf(input, mfParams);
     case 'sigmf'
        member =helper.sigmf(input, mfParams);
     case 'smf'
        member =helper.smf(input, mfParams);
     case 'psigmf'
        member =helper.psigmf(input, mfParams);
     case 'pimf'
        member =helper.pimf(input, mfParams);
     case 'gbellmf'
        member =helper.gbellmf(input, mfParams);
     case 'gauss2mf'
        member =helper.gauss2mf(input, mfParams);
     case 'dsigmf'
        member =helper.dsigmf(input, mfParams);              
end
end

