docker volume create sim_data    #for input and output of the simulation
docker volume create shared_data #for shared data like material database

docker run -d \
     --mount \
     'type=volume, \
      source=sim_data, \
      dst=/sim_data' \ 
     
