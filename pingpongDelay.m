classdef pingpongDelay < audioPlugin
  properties
    delayMs = 250
    wet = 0.7
    dry = 0.5
    fb = 0.6
  end
  properties (Constant)
    PluginInterface = ...
      audioPluginInterface( ...
      audioPluginParameter('delayMs', ...
      'Mapping', {'lin', 0, 500}))

  end
  methods
    function out = process(plugin, in)
        k = size(in,1);
        out = zeros(k,2);
      delaySamples = fix(plugin.delayMs/1000 * 44100);
      y = zeros(length(in)+(delaySamples*3),2); 
      s = y;
  

        for n = 1:length(in) 
            if n < delaySamples+1
                s(n,1) = in(n,1);
                s(n,2) = in(n,2);
            else 
                s(n,1) = in(n,1) + plugin.fb*s(n-delaySamples,1); 
                s(n,2) = in(n,2) + plugin.fb*s(n-delaySamples,2);  
            end
        end

        for n = 1:length(in) 
            if n < delaySamples+1
                y(n,1) = s(n,2);
                y(n,2) = s(n,1);
            else
                y(n,1) = plugin.dry*in(n,1) + plugin.wet*s(n,2);
                y(n,2) = plugin.dry*in(n,2) + plugin.wet*s(n,1);
            end
        
            out(n,1) = y(n,1);
            out(n,2) = y(n,2);
        end
        
        
    end
  end
end