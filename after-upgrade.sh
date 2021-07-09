#!/bin/bash
IP=$(curl -s http://whatismyip.akamai.com)
TARGET1=/opt/freeswitch/conf/sip_profiles/external.xml
TARGET2=/usr/local/bigbluebutton/bbb-webrtc-sfu/config/default.yml

xmlstarlet edit --inplace --update '//param[@name="local_ip_v4"]/@value' --value "\$\${external_rtp_ip}" $TARGET1
xmlstarlet edit --inplace --update '//param[@name="local_ip_v4"]/@value' --value "\$\${external_sip_ip}" $TARGET1
yq w -i $TARGET2 kurento[0].ip "$IP"
yq w -i $TARGET2 freeswitch.ip "$IP"
yq w -i $TARGET2 freeswitch.sip_ip "$IP"
yq w -i /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml public.media.sipjsHackViaWs true
bbb-conf --restart