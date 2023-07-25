#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


#define READ_END 0
#define WRITE_END 1
#define PIPES_ENDS 2

int main(){

  int child_pipe[PIPES_ENDS];
  int parent_pipe[PIPES_ENDS];

  if(pipe(pingpong) == -1 || pipe(pingpong) == -1){
    printf("Error while creating a pipe");
    exit(0);
  }

  int pid = fork();

  if(pid == -1){
    printf("Error while creating a fork");
    exit(0);
  }
  else if(pid == 0){
    close(child_pipe[READ_END]);
    close(parent_pipe[WRITE_END]);

    char pong;

    read(pipe_parent[READ_END], &pong, sizeof(pong));
    printf("%d: received ping\n", getpid());

    write(child_pipe[WRITE_END], &pong, sizeof(pong));

    close(child_pipe[WRITE_END]);
    close(parent_pipe[READ_END]);

  }
  else{
      close(child_pipe[WRITE_END]);
      close(parent_pipe[READ_END]);

      char ping = 'S';

      write(parent_pipe[WRITE_END], &ping, sizeof(ping));

      char pong;

      read(child_pipe[READ_END], &pong, sizeof(pong));
      printf("%d: received pong\n", getpid());
      close(child_pipe[READ_END]);
      close(parent_pipe[WRITE_END]);
  }
  exit(0);

}
