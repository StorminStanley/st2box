FROM stackstorm/st2exporter
LABEL com.stackstorm.service.provides="client"

ENV ST2_SERVICE ""

ADD ./config /.st2/config
ENV ST2_CONFIG_FILE /.st2/config
