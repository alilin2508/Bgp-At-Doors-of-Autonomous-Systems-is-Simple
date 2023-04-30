FROM frrouting/frr
RUN echo "package manager encapulate all the protocols services (BGPD OSPDF IS-IS) (before was quagga)"
RUN apk update
RUN apk upgrade
RUN sed -i 's/zebra=no/zebra=yes/g' /etc/frr/daemons
RUN sed -i 's/bgpd=no/bgpd=yes/g' /etc/frr/daemons
RUN sed -i 's/ospfd=no/ospfd=yes/g' /etc/frr/daemons
RUN sed -i 's/isisd=no/isisd=yes/g' /etc/frr/daemons
RUN mkdir -p /scripts_p2
COPY ./scripts_p2 /scripts_p2
RUN mkdir -p /scripts_p3
COPY ./scripts_p3 /scripts_p3
