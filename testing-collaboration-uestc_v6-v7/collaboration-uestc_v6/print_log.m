function print_log(level,msg)
% Prints debug output.
% (c) Josep Colom Ikuno, INTHFT, 2008
% output:   msg   ... msg to print, a string
%           level ... debug level

global netconfig;
if netconfig.debug_level>=level
    msg = strrep(msg,'\','\\'); % str=strrep(str1, str2, str3)����str1�ڵ��������ַ���str2�滻Ϊstr3
    msg = strrep(msg,'\\n','\n');
    msg = strrep(msg,'\network','\\network');
    fprintf(msg);
end
