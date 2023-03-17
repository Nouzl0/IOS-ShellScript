# argument options      
./mole -h                                                       #0 - DONE
        
./mole file                                                     #1 - DONE
./mole -g group file                                            #1 - DONE

./mole                                                          #2 - DONE
./mole -m                                                       #2 - DONE
./mole directory                                                #2 - DONE
./mole -m directory                                             #2 - DONE

./mole -g group                                                 #2 - DONE
./mole -a 2010-01-01                                            #2 - DONE
./mole -b 2020-02-02                                            #2 - DONE
./mole -a 2010-01-01 -b 2020-02-02                              #2 - DONE
./mole -g group -a 2010-01-01                                   #2 - DONE
./mole -g group -b 2020-02-02                                   #2 - DONE
./mole -a 2021-01-01 -g group                                   #2 - DONE
./mole -b 2020-02-02 -g group                                   #2 - DONE
./mole -a 2010-01-01 -b 2020-02-02 -g group                     #2 - DONE
./mole -b 2020-02-02 -a 2010-01-01 -g group                     #2 - DONE
./mole -a 2010-01-01 -g group -b 2020-02-02                     #2 - DONE
./mole -b 2020-02-02 -g group -a 2010-01-01                     #2 - DONE
./mole -g group -a 2010-01-01 -b 2020-02-02                     #2 - DONE
./mole -g group -b 2020-02-02 -a 2010-01-01                     #2 - DONE

./mole -m -g group                                              #2 - DONE
./mole -m -a 2010-01-01                                         #2 - DONE
./mole -m -b 2020-02-02                                         #2 - DONE
./mole -m -a 2010-01-01 -b 2020-02-02                           #2 - DONE
./mole -m -g group -a 2010-01-01                                #2 - DONE
./mole -m -g group -b 2020-02-02                                #2 - DONE
./mole -m -a 2021-01-01 -g group                                #2 - DONE
./mole -m -b 2020-02-02 -g group                                #2 - DONE
./mole -m -a 2010-01-01 -b 2020-02-02 -g group                  #2 - DONE
./mole -m -b 2020-02-02 -a 2010-01-01 -g group                  #2 - DONE
./mole -m -a 2010-01-01 -g group -b 2020-02-02                  #2 - DONE
./mole -m -b 2020-02-02 -g group -a 2010-01-01                  #2 - DONE
./mole -m -g group -b 2020-02-02 -a 2010-01-01                  #2 - DONE
./mole -m -g group -a 2010-01-01 -b 2020-02-02                  #2 - DONE

./mole -g group directory                                       #2 - DONE
./mole -a 2010-01-01 directory                                  #2 - DONE
./mole -b 2020-02-02 directory                                  #2 - DONE
./mole -a 2010-01-01 -b 2020-02-02 directory                    #2 - DONE
./mole -g group -a 2010-01-01 directory                         #2 - DONE
./mole -g group -b 2020-02-02 directory                         #2 - DONE
./mole -a 2021-01-01 -g group directory                         #2 - DONE
./mole -b 2020-02-02 -g group directory                         #2 - DONE
./mole -a 2010-01-01 -b 2020-02-02 -g group directory           #2 - DONE
./mole -b 2020-02-02 -a 2010-01-01 -g group directory           #2 - DONE
./mole -a 2010-01-01 -g group -b 2020-02-02 directory           #2 - DONE
./mole -b 2020-02-02 -g group -a 2010-01-01 directory           #2 - DONE
./mole -g group -a 2010-01-01 -b 2020-02-02 directory           #2 - DONE
./mole -g group -b 2020-02-02 -a 2010-01-01 directory           #2 - DONE

./mole -m -g group directory                                    #2 - DONE
./mole -m -a 2010-01-01 directory                               #2 - DONE
./mole -m -b 2020-02-02 directory                               #2 - DONE
./mole -m -a 2010-01-01 -b 2020-02-02 directory                 #2 - DONE
./mole -m -g group -a 2010-01-01 directory                      #2 - DONE
./mole -m -g group -b 2020-02-02 directory                      #2 - DONE
./mole -m -a 2021-01-01 -g group directory                      #2 - DONE
./mole -m -b 2020-02-02 -g group directory                      #2 - DONE
./mole -m -a 2010-01-01 -b 2020-02-02 -g group directory        #2 - DONE
./mole -m -b 2020-02-02 -a 2010-01-01 -g group directory        #2 - DONE
./mole -m -a 2010-01-01 -g group -b 2020-02-02 directory        #2 - DONE
./mole -m -b 2020-02-02 -g group -a 2010-01-01 directory        #2 - DONE
./mole -m -g group -a 2010-01-01 -b 2020-02-02 directory        #2 - DONE
./mole -m -g group -b 2020-02-02 -a 2010-01-01 directory        #2 - DONE

./mole list                                                     #3 - DONE
./mole list directory                                           #3 - DONE

./mole list -g group                                            #3 - DONE
./mole list -a 2010-01-01                                       #3 - DONE
./mole list -b 2020-02-02                                       #3 - DONE
./mole list -a 2010-01-01 -b 2020-02-02                         #3 - DONE
./mole list -g group -a 2010-01-01                              #3 - DONE
./mole list -g group -b 2020-02-02                              #3 - DONE
./mole list -a 2021-01-01 -g group                              #3 - DONE
./mole list -b 2020-02-02 -g group                              #3 - DONE
./mole list -a 2010-01-01 -b 2020-02-02 -g group                #3 - DONE
./mole list -b 2020-02-02 -a 2010-01-01 -g group                #3 - DONE
./mole list -a 2010-01-01 -g group -b 2020-02-02                #3 - DONE
./mole list -b 2020-02-02 -g group -a 2010-01-01                #3 - DONE
./mole list -g group -a 2010-01-01 -b 2020-02-02                #3 - DONE
./mole list -g group -b 2020-02-02 -a 2010-01-01                #3 - DONE

./mole list -g group directory                                  #3 - DONE
./mole list -a 2010-01-01 directory                             #3 - DONE
./mole list -b 2020-02-02 directory                             #3 - DONE
./mole list -a 2010-01-01 -b 2020-02-02 directory               #3 - DONE
./mole list -g group -a 2010-01-01 directory                    #3 - DONE
./mole list -g group -b 2020-02-02 directory                    #3 - DONE
./mole list -a 2021-01-01 -g group directory                    #3 - DONE
./mole list -b 2020-02-02 -g group directory                    #3 - DONE
./mole list -a 2010-01-01 -b 2020-02-02 -g group directory      #3 - DONE
./mole list -b 2020-02-02 -a 2010-01-01 -g group directory      #3 - DONE
./mole list -a 2010-01-01 -g group -b 2020-02-02 directory      #3 - DONE
./mole list -b 2020-02-02 -g group -a 2010-01-01 directory      #3 - DONE
./mole list -g group -a 2010-01-01 -b 2020-02-02 directory      #3 - DONE
./mole list -g group -b 2020-02-02 -a 2010-01-01 directory      #3 - DONE

./mole secret-log                                               #4 - DONE
./mole secret-log -b 2020-02-02                                 #4 - DONE
./mole secret-log -a 2010-01-01                                 #4 - DONE
./mole secret-log directory                                     #4 - DONE
./mole secret-log -b 2020-02-02 -a 2010-01-01                   #4 - DONE
./mole secret-log -b 2020-02-02 directory                       #4 - DONE
./mole secret-log -a 2010-01-01 directory                       #4 - DONE
./mole secret-log -b 2020-02-02 -a 2010-01-01 directory         #4 - DONE