{config, pkgs, host, ...}:

{
  home.file = {
    ".config/touchegg/touchegg.conf".text = with host; if hostName == "tablet" then ''
        <touchégg>
          <settings>
            <property name="composed_gestures_time">111</property>
            <property name="action_execute_threshold">0</property>
          </settings>
          <application name="All">
            <gesture type="SWIPE" fingers="2" direction="UP">
              <action type="RUN_COMMAND">
                <repeat>false</repeat>
                <command>onboard</command>
                <on>begin</on>
              </action>
            </gesture>
            <gesture type="PINCH" fingers="2" direction="IN">
              <action type="SEND_KEYS">
                <repeat>true</repeat>
                <modifiers>Control_L</modifiers>
                <keys>KP_Subtract</keys>
                <decreaseKeys>KP_Add</decreaseKeys>
              </action>
            </gesture>
            <gesture type="PINCH" fingers="2" direction="OUT">
              <action type="SEND_KEYS">
                <repeat>true</repeat>
                <modifiers>Control_L</modifiers>
                <keys>KP_Add</keys>
                <decreaseKeys>KP_Subtract</decreaseKeys>
              </action>
            </gesture>
            <gesture type="SWIPE" fingers="3" direction="UP">
              <action type="SEND_KEYS">
                <repeat>false</repeat>
                <modifiers>Super_L</modifiers>
                <keys>space</keys>
                <on>begin</on>
              </action>
            </gesture>
            <gesture type="SWIPE" fingers="4" direction="UP">
              <action type="SEND_KEYS">
                <repeat>false</repeat>
                <modifiers>Super_L</modifiers>
                <keys>B</keys>
                <on>begin</on>
              </action>
            </gesture> 
            <gesture type="PINCH" fingers="3" direction="IN">
              <action type="CLOSE_WINDOW">
                <animate>true</animate>
                <color>F84A53</color>
                <borderColor>F84A53</borderColor>
              </action>
            </gesture>
            <gesture type="TAP" fingers="3" direction="UNKNOWN">
              <action type="MOUSE_CLICK">
                <button>2</button>
                <on>begin</on>
              </action>
            </gesture>
            <gesture type="TAP" fingers="2" direction="UNKNOWN">
              <action type="MOUSE_CLICK">
                <button>3</button>
                <on>begin</on>
              </action>
            </gesture>
            <gesture type="TAP" fingers="4" direction="UNKNOWN">
              <action type="SEND_KEYS">
                <repeat>false</repeat>
                <modifiers>Super_L</modifiers>
                <keys>F</keys>
                <on>begin</on>
              </action>
            </gesture> 
          </application>
        </touchégg>
    ''
  else ''
        <touchégg>
          <settings>
            <property name="composed_gestures_time">111</property>
            <property name="action_execute_threshold">0</property>
          </settings>
          <application name="All">
            <gesture type="PINCH" fingers="2" direction="IN">
              <action type="SEND_KEYS">
                <repeat>true</repeat>
                <modifiers>Control_L</modifiers>
                <keys>KP_Subtract</keys>
                <decreaseKeys>KP_Add</decreaseKeys>
              </action>
            </gesture>
            <gesture type="PINCH" fingers="2" direction="OUT">
              <action type="SEND_KEYS">
                <repeat>true</repeat>
                <modifiers>Control_L</modifiers>
                <keys>KP_Add</keys>
                <decreaseKeys>KP_Subtract</decreaseKeys>
              </action>
            </gesture>
            <gesture type="SWIPE" fingers="3" direction="UP">
              <action type="SEND_KEYS">
                <repeat>false</repeat>
                <modifiers>Super_L</modifiers>
                <keys>space</keys>
                <on>begin</on>
              </action>
            </gesture>
            <gesture type="SWIPE" fingers="4" direction="UP">
              <action type="SEND_KEYS">
                <repeat>false</repeat>
                <modifiers>Super_L</modifiers>
                <keys>B</keys>
                <on>begin</on>
              </action>
            </gesture> 
            <gesture type="PINCH" fingers="3" direction="IN">
              <action type="CLOSE_WINDOW">
                <animate>true</animate>
                <color>F84A53</color>
                <borderColor>F84A53</borderColor>
              </action>
            </gesture>
            <gesture type="TAP" fingers="3" direction="UNKNOWN">
              <action type="MOUSE_CLICK">
                <button>2</button>
                <on>begin</on>
              </action>
            </gesture>
            <gesture type="TAP" fingers="2" direction="UNKNOWN">
              <action type="MOUSE_CLICK">
                <button>3</button>
                <on>begin</on>
              </action>
            </gesture>
            <gesture type="TAP" fingers="4" direction="UNKNOWN">
              <action type="SEND_KEYS">
                <repeat>false</repeat>
                <modifiers>Super_L</modifiers>
                <keys>F</keys>
                <on>begin</on>
              </action>
            </gesture> 
          </application>
        </touchégg>
    '';
  };
}
