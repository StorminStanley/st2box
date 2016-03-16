FROM stackstorm/st2actionrunner

ADD ./st2.conf /etc/st2/st2.conf

ENV ST2_SERVICE ""
CMD st2-register-content --config-file /etc/st2/st2.conf --register-all
