
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xori	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	addi	a3,a3,797 # 1f31d <__global_pointer$+0x1d4a4>
      1c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	addi	a2,a2,423 # 41a7 <__global_pointer$+0x232e>
      26:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <__global_pointer$+0xffffffffffffd673>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
    if (x < 0)
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      3e:	17fd                	addi	a5,a5,-1
    *ctx = x;
      40:	e11c                	sd	a5,0(a0)
    return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	addi	sp,sp,16
      4a:	8082                	ret
        x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      58:	1141                	addi	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      60:	00001517          	auipc	a0,0x1
      64:	62050513          	addi	a0,a0,1568 # 1680 <rand_next>
      68:	00000097          	auipc	ra,0x0
      6c:	f98080e7          	jalr	-104(ra) # 0 <do_rand>
}
      70:	60a2                	ld	ra,8(sp)
      72:	6402                	ld	s0,0(sp)
      74:	0141                	addi	sp,sp,16
      76:	8082                	ret

0000000000000078 <go>:

void
go(int which_child)
{
      78:	7159                	addi	sp,sp,-112
      7a:	f486                	sd	ra,104(sp)
      7c:	f0a2                	sd	s0,96(sp)
      7e:	eca6                	sd	s1,88(sp)
      80:	e8ca                	sd	s2,80(sp)
      82:	e4ce                	sd	s3,72(sp)
      84:	e0d2                	sd	s4,64(sp)
      86:	fc56                	sd	s5,56(sp)
      88:	f85a                	sd	s6,48(sp)
      8a:	1880                	addi	s0,sp,112
      8c:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      8e:	4501                	li	a0,0
      90:	00001097          	auipc	ra,0x1
      94:	e56080e7          	jalr	-426(ra) # ee6 <sbrk>
      98:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      9a:	00001517          	auipc	a0,0x1
      9e:	2de50513          	addi	a0,a0,734 # 1378 <malloc+0xe4>
      a2:	00001097          	auipc	ra,0x1
      a6:	e24080e7          	jalr	-476(ra) # ec6 <mkdir>
  if(chdir("grindir") != 0){
      aa:	00001517          	auipc	a0,0x1
      ae:	2ce50513          	addi	a0,a0,718 # 1378 <malloc+0xe4>
      b2:	00001097          	auipc	ra,0x1
      b6:	e1c080e7          	jalr	-484(ra) # ece <chdir>
      ba:	cd11                	beqz	a0,d6 <go+0x5e>
    printf("grind: chdir grindir failed\n");
      bc:	00001517          	auipc	a0,0x1
      c0:	2c450513          	addi	a0,a0,708 # 1380 <malloc+0xec>
      c4:	00001097          	auipc	ra,0x1
      c8:	112080e7          	jalr	274(ra) # 11d6 <printf>
    exit(1);
      cc:	4505                	li	a0,1
      ce:	00001097          	auipc	ra,0x1
      d2:	d90080e7          	jalr	-624(ra) # e5e <exit>
  }
  chdir("/");
      d6:	00001517          	auipc	a0,0x1
      da:	2ca50513          	addi	a0,a0,714 # 13a0 <malloc+0x10c>
      de:	00001097          	auipc	ra,0x1
      e2:	df0080e7          	jalr	-528(ra) # ece <chdir>
  
  while(1){
    iters++;
    if((iters % 500) == 0)
      e6:	00001997          	auipc	s3,0x1
      ea:	2ca98993          	addi	s3,s3,714 # 13b0 <malloc+0x11c>
      ee:	c489                	beqz	s1,f8 <go+0x80>
      f0:	00001997          	auipc	s3,0x1
      f4:	2b898993          	addi	s3,s3,696 # 13a8 <malloc+0x114>
    iters++;
      f8:	4485                	li	s1,1
  int fd = -1;
      fa:	597d                	li	s2,-1
      close(fd);
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
      fc:	00001a17          	auipc	s4,0x1
     100:	594a0a13          	addi	s4,s4,1428 # 1690 <buf.0>
     104:	a825                	j	13c <go+0xc4>
      close(open("grindir/../a", O_CREATE|O_RDWR));
     106:	20200593          	li	a1,514
     10a:	00001517          	auipc	a0,0x1
     10e:	2ae50513          	addi	a0,a0,686 # 13b8 <malloc+0x124>
     112:	00001097          	auipc	ra,0x1
     116:	d8c080e7          	jalr	-628(ra) # e9e <open>
     11a:	00001097          	auipc	ra,0x1
     11e:	d6c080e7          	jalr	-660(ra) # e86 <close>
    iters++;
     122:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     124:	1f400793          	li	a5,500
     128:	02f4f7b3          	remu	a5,s1,a5
     12c:	eb81                	bnez	a5,13c <go+0xc4>
      write(1, which_child?"B":"A", 1);
     12e:	4605                	li	a2,1
     130:	85ce                	mv	a1,s3
     132:	4505                	li	a0,1
     134:	00001097          	auipc	ra,0x1
     138:	d4a080e7          	jalr	-694(ra) # e7e <write>
    int what = rand() % 23;
     13c:	00000097          	auipc	ra,0x0
     140:	f1c080e7          	jalr	-228(ra) # 58 <rand>
     144:	47dd                	li	a5,23
     146:	02f5653b          	remw	a0,a0,a5
    if(what == 1){
     14a:	4785                	li	a5,1
     14c:	faf50de3          	beq	a0,a5,106 <go+0x8e>
    } else if(what == 2){
     150:	4789                	li	a5,2
     152:	18f50563          	beq	a0,a5,2dc <go+0x264>
    } else if(what == 3){
     156:	478d                	li	a5,3
     158:	1af50163          	beq	a0,a5,2fa <go+0x282>
    } else if(what == 4){
     15c:	4791                	li	a5,4
     15e:	1af50763          	beq	a0,a5,30c <go+0x294>
    } else if(what == 5){
     162:	4795                	li	a5,5
     164:	1ef50b63          	beq	a0,a5,35a <go+0x2e2>
    } else if(what == 6){
     168:	4799                	li	a5,6
     16a:	20f50963          	beq	a0,a5,37c <go+0x304>
    } else if(what == 7){
     16e:	479d                	li	a5,7
     170:	22f50763          	beq	a0,a5,39e <go+0x326>
    } else if(what == 8){
     174:	47a1                	li	a5,8
     176:	22f50d63          	beq	a0,a5,3b0 <go+0x338>
    } else if(what == 9){
     17a:	47a5                	li	a5,9
     17c:	24f50363          	beq	a0,a5,3c2 <go+0x34a>
      mkdir("grindir/../a");
      close(open("a/../a/./a", O_CREATE|O_RDWR));
      unlink("a/a");
    } else if(what == 10){
     180:	47a9                	li	a5,10
     182:	26f50f63          	beq	a0,a5,400 <go+0x388>
      mkdir("/../b");
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
      unlink("b/b");
    } else if(what == 11){
     186:	47ad                	li	a5,11
     188:	2af50b63          	beq	a0,a5,43e <go+0x3c6>
      unlink("b");
      link("../grindir/./../a", "../b");
    } else if(what == 12){
     18c:	47b1                	li	a5,12
     18e:	2cf50d63          	beq	a0,a5,468 <go+0x3f0>
      unlink("../grindir/../a");
      link(".././b", "/grindir/../a");
    } else if(what == 13){
     192:	47b5                	li	a5,13
     194:	2ef50f63          	beq	a0,a5,492 <go+0x41a>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 14){
     198:	47b9                	li	a5,14
     19a:	32f50a63          	beq	a0,a5,4ce <go+0x456>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 15){
     19e:	47bd                	li	a5,15
     1a0:	36f50e63          	beq	a0,a5,51c <go+0x4a4>
      sbrk(6011);
    } else if(what == 16){
     1a4:	47c1                	li	a5,16
     1a6:	38f50363          	beq	a0,a5,52c <go+0x4b4>
      if(sbrk(0) > break0)
        sbrk(-(sbrk(0) - break0));
    } else if(what == 17){
     1aa:	47c5                	li	a5,17
     1ac:	3af50363          	beq	a0,a5,552 <go+0x4da>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
      wait(0);
    } else if(what == 18){
     1b0:	47c9                	li	a5,18
     1b2:	42f50963          	beq	a0,a5,5e4 <go+0x56c>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 19){
     1b6:	47cd                	li	a5,19
     1b8:	46f50d63          	beq	a0,a5,632 <go+0x5ba>
        exit(1);
      }
      close(fds[0]);
      close(fds[1]);
      wait(0);
    } else if(what == 20){
     1bc:	47d1                	li	a5,20
     1be:	54f50e63          	beq	a0,a5,71a <go+0x6a2>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 21){
     1c2:	47d5                	li	a5,21
     1c4:	5ef50c63          	beq	a0,a5,7bc <go+0x744>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
      unlink("c");
    } else if(what == 22){
     1c8:	47d9                	li	a5,22
     1ca:	f4f51ce3          	bne	a0,a5,122 <go+0xaa>
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     1ce:	f9840513          	addi	a0,s0,-104
     1d2:	00001097          	auipc	ra,0x1
     1d6:	c9c080e7          	jalr	-868(ra) # e6e <pipe>
     1da:	6e054563          	bltz	a0,8c4 <go+0x84c>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     1de:	fa040513          	addi	a0,s0,-96
     1e2:	00001097          	auipc	ra,0x1
     1e6:	c8c080e7          	jalr	-884(ra) # e6e <pipe>
     1ea:	6e054b63          	bltz	a0,8e0 <go+0x868>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     1ee:	00001097          	auipc	ra,0x1
     1f2:	c68080e7          	jalr	-920(ra) # e56 <fork>
      if(pid1 == 0){
     1f6:	70050363          	beqz	a0,8fc <go+0x884>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     1fa:	7a054b63          	bltz	a0,9b0 <go+0x938>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     1fe:	00001097          	auipc	ra,0x1
     202:	c58080e7          	jalr	-936(ra) # e56 <fork>
      if(pid2 == 0){
     206:	7c050363          	beqz	a0,9cc <go+0x954>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     20a:	08054fe3          	bltz	a0,aa8 <go+0xa30>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     20e:	f9842503          	lw	a0,-104(s0)
     212:	00001097          	auipc	ra,0x1
     216:	c74080e7          	jalr	-908(ra) # e86 <close>
      close(aa[1]);
     21a:	f9c42503          	lw	a0,-100(s0)
     21e:	00001097          	auipc	ra,0x1
     222:	c68080e7          	jalr	-920(ra) # e86 <close>
      close(bb[1]);
     226:	fa442503          	lw	a0,-92(s0)
     22a:	00001097          	auipc	ra,0x1
     22e:	c5c080e7          	jalr	-932(ra) # e86 <close>
      char buf[4] = { 0, 0, 0, 0 };
     232:	f8042823          	sw	zero,-112(s0)
      read(bb[0], buf+0, 1);
     236:	4605                	li	a2,1
     238:	f9040593          	addi	a1,s0,-112
     23c:	fa042503          	lw	a0,-96(s0)
     240:	00001097          	auipc	ra,0x1
     244:	c36080e7          	jalr	-970(ra) # e76 <read>
      read(bb[0], buf+1, 1);
     248:	4605                	li	a2,1
     24a:	f9140593          	addi	a1,s0,-111
     24e:	fa042503          	lw	a0,-96(s0)
     252:	00001097          	auipc	ra,0x1
     256:	c24080e7          	jalr	-988(ra) # e76 <read>
      read(bb[0], buf+2, 1);
     25a:	4605                	li	a2,1
     25c:	f9240593          	addi	a1,s0,-110
     260:	fa042503          	lw	a0,-96(s0)
     264:	00001097          	auipc	ra,0x1
     268:	c12080e7          	jalr	-1006(ra) # e76 <read>
      close(bb[0]);
     26c:	fa042503          	lw	a0,-96(s0)
     270:	00001097          	auipc	ra,0x1
     274:	c16080e7          	jalr	-1002(ra) # e86 <close>
      int st1, st2;
      wait(&st1);
     278:	f9440513          	addi	a0,s0,-108
     27c:	00001097          	auipc	ra,0x1
     280:	bea080e7          	jalr	-1046(ra) # e66 <wait>
      wait(&st2);
     284:	fa840513          	addi	a0,s0,-88
     288:	00001097          	auipc	ra,0x1
     28c:	bde080e7          	jalr	-1058(ra) # e66 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     290:	f9442783          	lw	a5,-108(s0)
     294:	fa842703          	lw	a4,-88(s0)
     298:	8fd9                	or	a5,a5,a4
     29a:	2781                	sext.w	a5,a5
     29c:	ef89                	bnez	a5,2b6 <go+0x23e>
     29e:	00001597          	auipc	a1,0x1
     2a2:	39258593          	addi	a1,a1,914 # 1630 <malloc+0x39c>
     2a6:	f9040513          	addi	a0,s0,-112
     2aa:	00001097          	auipc	ra,0x1
     2ae:	962080e7          	jalr	-1694(ra) # c0c <strcmp>
     2b2:	e60508e3          	beqz	a0,122 <go+0xaa>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     2b6:	f9040693          	addi	a3,s0,-112
     2ba:	fa842603          	lw	a2,-88(s0)
     2be:	f9442583          	lw	a1,-108(s0)
     2c2:	00001517          	auipc	a0,0x1
     2c6:	37650513          	addi	a0,a0,886 # 1638 <malloc+0x3a4>
     2ca:	00001097          	auipc	ra,0x1
     2ce:	f0c080e7          	jalr	-244(ra) # 11d6 <printf>
        exit(1);
     2d2:	4505                	li	a0,1
     2d4:	00001097          	auipc	ra,0x1
     2d8:	b8a080e7          	jalr	-1142(ra) # e5e <exit>
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     2dc:	20200593          	li	a1,514
     2e0:	00001517          	auipc	a0,0x1
     2e4:	0e850513          	addi	a0,a0,232 # 13c8 <malloc+0x134>
     2e8:	00001097          	auipc	ra,0x1
     2ec:	bb6080e7          	jalr	-1098(ra) # e9e <open>
     2f0:	00001097          	auipc	ra,0x1
     2f4:	b96080e7          	jalr	-1130(ra) # e86 <close>
     2f8:	b52d                	j	122 <go+0xaa>
      unlink("grindir/../a");
     2fa:	00001517          	auipc	a0,0x1
     2fe:	0be50513          	addi	a0,a0,190 # 13b8 <malloc+0x124>
     302:	00001097          	auipc	ra,0x1
     306:	bac080e7          	jalr	-1108(ra) # eae <unlink>
     30a:	bd21                	j	122 <go+0xaa>
      if(chdir("grindir") != 0){
     30c:	00001517          	auipc	a0,0x1
     310:	06c50513          	addi	a0,a0,108 # 1378 <malloc+0xe4>
     314:	00001097          	auipc	ra,0x1
     318:	bba080e7          	jalr	-1094(ra) # ece <chdir>
     31c:	e115                	bnez	a0,340 <go+0x2c8>
      unlink("../b");
     31e:	00001517          	auipc	a0,0x1
     322:	0c250513          	addi	a0,a0,194 # 13e0 <malloc+0x14c>
     326:	00001097          	auipc	ra,0x1
     32a:	b88080e7          	jalr	-1144(ra) # eae <unlink>
      chdir("/");
     32e:	00001517          	auipc	a0,0x1
     332:	07250513          	addi	a0,a0,114 # 13a0 <malloc+0x10c>
     336:	00001097          	auipc	ra,0x1
     33a:	b98080e7          	jalr	-1128(ra) # ece <chdir>
     33e:	b3d5                	j	122 <go+0xaa>
        printf("grind: chdir grindir failed\n");
     340:	00001517          	auipc	a0,0x1
     344:	04050513          	addi	a0,a0,64 # 1380 <malloc+0xec>
     348:	00001097          	auipc	ra,0x1
     34c:	e8e080e7          	jalr	-370(ra) # 11d6 <printf>
        exit(1);
     350:	4505                	li	a0,1
     352:	00001097          	auipc	ra,0x1
     356:	b0c080e7          	jalr	-1268(ra) # e5e <exit>
      close(fd);
     35a:	854a                	mv	a0,s2
     35c:	00001097          	auipc	ra,0x1
     360:	b2a080e7          	jalr	-1238(ra) # e86 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     364:	20200593          	li	a1,514
     368:	00001517          	auipc	a0,0x1
     36c:	08050513          	addi	a0,a0,128 # 13e8 <malloc+0x154>
     370:	00001097          	auipc	ra,0x1
     374:	b2e080e7          	jalr	-1234(ra) # e9e <open>
     378:	892a                	mv	s2,a0
     37a:	b365                	j	122 <go+0xaa>
      close(fd);
     37c:	854a                	mv	a0,s2
     37e:	00001097          	auipc	ra,0x1
     382:	b08080e7          	jalr	-1272(ra) # e86 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     386:	20200593          	li	a1,514
     38a:	00001517          	auipc	a0,0x1
     38e:	06e50513          	addi	a0,a0,110 # 13f8 <malloc+0x164>
     392:	00001097          	auipc	ra,0x1
     396:	b0c080e7          	jalr	-1268(ra) # e9e <open>
     39a:	892a                	mv	s2,a0
     39c:	b359                	j	122 <go+0xaa>
      write(fd, buf, sizeof(buf));
     39e:	3e700613          	li	a2,999
     3a2:	85d2                	mv	a1,s4
     3a4:	854a                	mv	a0,s2
     3a6:	00001097          	auipc	ra,0x1
     3aa:	ad8080e7          	jalr	-1320(ra) # e7e <write>
     3ae:	bb95                	j	122 <go+0xaa>
      read(fd, buf, sizeof(buf));
     3b0:	3e700613          	li	a2,999
     3b4:	85d2                	mv	a1,s4
     3b6:	854a                	mv	a0,s2
     3b8:	00001097          	auipc	ra,0x1
     3bc:	abe080e7          	jalr	-1346(ra) # e76 <read>
     3c0:	b38d                	j	122 <go+0xaa>
      mkdir("grindir/../a");
     3c2:	00001517          	auipc	a0,0x1
     3c6:	ff650513          	addi	a0,a0,-10 # 13b8 <malloc+0x124>
     3ca:	00001097          	auipc	ra,0x1
     3ce:	afc080e7          	jalr	-1284(ra) # ec6 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     3d2:	20200593          	li	a1,514
     3d6:	00001517          	auipc	a0,0x1
     3da:	03a50513          	addi	a0,a0,58 # 1410 <malloc+0x17c>
     3de:	00001097          	auipc	ra,0x1
     3e2:	ac0080e7          	jalr	-1344(ra) # e9e <open>
     3e6:	00001097          	auipc	ra,0x1
     3ea:	aa0080e7          	jalr	-1376(ra) # e86 <close>
      unlink("a/a");
     3ee:	00001517          	auipc	a0,0x1
     3f2:	03250513          	addi	a0,a0,50 # 1420 <malloc+0x18c>
     3f6:	00001097          	auipc	ra,0x1
     3fa:	ab8080e7          	jalr	-1352(ra) # eae <unlink>
     3fe:	b315                	j	122 <go+0xaa>
      mkdir("/../b");
     400:	00001517          	auipc	a0,0x1
     404:	02850513          	addi	a0,a0,40 # 1428 <malloc+0x194>
     408:	00001097          	auipc	ra,0x1
     40c:	abe080e7          	jalr	-1346(ra) # ec6 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     410:	20200593          	li	a1,514
     414:	00001517          	auipc	a0,0x1
     418:	01c50513          	addi	a0,a0,28 # 1430 <malloc+0x19c>
     41c:	00001097          	auipc	ra,0x1
     420:	a82080e7          	jalr	-1406(ra) # e9e <open>
     424:	00001097          	auipc	ra,0x1
     428:	a62080e7          	jalr	-1438(ra) # e86 <close>
      unlink("b/b");
     42c:	00001517          	auipc	a0,0x1
     430:	01450513          	addi	a0,a0,20 # 1440 <malloc+0x1ac>
     434:	00001097          	auipc	ra,0x1
     438:	a7a080e7          	jalr	-1414(ra) # eae <unlink>
     43c:	b1dd                	j	122 <go+0xaa>
      unlink("b");
     43e:	00001517          	auipc	a0,0x1
     442:	fca50513          	addi	a0,a0,-54 # 1408 <malloc+0x174>
     446:	00001097          	auipc	ra,0x1
     44a:	a68080e7          	jalr	-1432(ra) # eae <unlink>
      link("../grindir/./../a", "../b");
     44e:	00001597          	auipc	a1,0x1
     452:	f9258593          	addi	a1,a1,-110 # 13e0 <malloc+0x14c>
     456:	00001517          	auipc	a0,0x1
     45a:	ff250513          	addi	a0,a0,-14 # 1448 <malloc+0x1b4>
     45e:	00001097          	auipc	ra,0x1
     462:	a60080e7          	jalr	-1440(ra) # ebe <link>
     466:	b975                	j	122 <go+0xaa>
      unlink("../grindir/../a");
     468:	00001517          	auipc	a0,0x1
     46c:	ff850513          	addi	a0,a0,-8 # 1460 <malloc+0x1cc>
     470:	00001097          	auipc	ra,0x1
     474:	a3e080e7          	jalr	-1474(ra) # eae <unlink>
      link(".././b", "/grindir/../a");
     478:	00001597          	auipc	a1,0x1
     47c:	f7058593          	addi	a1,a1,-144 # 13e8 <malloc+0x154>
     480:	00001517          	auipc	a0,0x1
     484:	ff050513          	addi	a0,a0,-16 # 1470 <malloc+0x1dc>
     488:	00001097          	auipc	ra,0x1
     48c:	a36080e7          	jalr	-1482(ra) # ebe <link>
     490:	b949                	j	122 <go+0xaa>
      int pid = fork();
     492:	00001097          	auipc	ra,0x1
     496:	9c4080e7          	jalr	-1596(ra) # e56 <fork>
      if(pid == 0){
     49a:	c909                	beqz	a0,4ac <go+0x434>
      } else if(pid < 0){
     49c:	00054c63          	bltz	a0,4b4 <go+0x43c>
      wait(0);
     4a0:	4501                	li	a0,0
     4a2:	00001097          	auipc	ra,0x1
     4a6:	9c4080e7          	jalr	-1596(ra) # e66 <wait>
     4aa:	b9a5                	j	122 <go+0xaa>
        exit(0);
     4ac:	00001097          	auipc	ra,0x1
     4b0:	9b2080e7          	jalr	-1614(ra) # e5e <exit>
        printf("grind: fork failed\n");
     4b4:	00001517          	auipc	a0,0x1
     4b8:	fc450513          	addi	a0,a0,-60 # 1478 <malloc+0x1e4>
     4bc:	00001097          	auipc	ra,0x1
     4c0:	d1a080e7          	jalr	-742(ra) # 11d6 <printf>
        exit(1);
     4c4:	4505                	li	a0,1
     4c6:	00001097          	auipc	ra,0x1
     4ca:	998080e7          	jalr	-1640(ra) # e5e <exit>
      int pid = fork();
     4ce:	00001097          	auipc	ra,0x1
     4d2:	988080e7          	jalr	-1656(ra) # e56 <fork>
      if(pid == 0){
     4d6:	c909                	beqz	a0,4e8 <go+0x470>
      } else if(pid < 0){
     4d8:	02054563          	bltz	a0,502 <go+0x48a>
      wait(0);
     4dc:	4501                	li	a0,0
     4de:	00001097          	auipc	ra,0x1
     4e2:	988080e7          	jalr	-1656(ra) # e66 <wait>
     4e6:	b935                	j	122 <go+0xaa>
        fork();
     4e8:	00001097          	auipc	ra,0x1
     4ec:	96e080e7          	jalr	-1682(ra) # e56 <fork>
        fork();
     4f0:	00001097          	auipc	ra,0x1
     4f4:	966080e7          	jalr	-1690(ra) # e56 <fork>
        exit(0);
     4f8:	4501                	li	a0,0
     4fa:	00001097          	auipc	ra,0x1
     4fe:	964080e7          	jalr	-1692(ra) # e5e <exit>
        printf("grind: fork failed\n");
     502:	00001517          	auipc	a0,0x1
     506:	f7650513          	addi	a0,a0,-138 # 1478 <malloc+0x1e4>
     50a:	00001097          	auipc	ra,0x1
     50e:	ccc080e7          	jalr	-820(ra) # 11d6 <printf>
        exit(1);
     512:	4505                	li	a0,1
     514:	00001097          	auipc	ra,0x1
     518:	94a080e7          	jalr	-1718(ra) # e5e <exit>
      sbrk(6011);
     51c:	6505                	lui	a0,0x1
     51e:	77b50513          	addi	a0,a0,1915 # 177b <buf.0+0xeb>
     522:	00001097          	auipc	ra,0x1
     526:	9c4080e7          	jalr	-1596(ra) # ee6 <sbrk>
     52a:	bee5                	j	122 <go+0xaa>
      if(sbrk(0) > break0)
     52c:	4501                	li	a0,0
     52e:	00001097          	auipc	ra,0x1
     532:	9b8080e7          	jalr	-1608(ra) # ee6 <sbrk>
     536:	beaaf6e3          	bgeu	s5,a0,122 <go+0xaa>
        sbrk(-(sbrk(0) - break0));
     53a:	4501                	li	a0,0
     53c:	00001097          	auipc	ra,0x1
     540:	9aa080e7          	jalr	-1622(ra) # ee6 <sbrk>
     544:	40aa853b          	subw	a0,s5,a0
     548:	00001097          	auipc	ra,0x1
     54c:	99e080e7          	jalr	-1634(ra) # ee6 <sbrk>
     550:	bec9                	j	122 <go+0xaa>
      int pid = fork();
     552:	00001097          	auipc	ra,0x1
     556:	904080e7          	jalr	-1788(ra) # e56 <fork>
     55a:	8b2a                	mv	s6,a0
      if(pid == 0){
     55c:	c51d                	beqz	a0,58a <go+0x512>
      } else if(pid < 0){
     55e:	04054963          	bltz	a0,5b0 <go+0x538>
      if(chdir("../grindir/..") != 0){
     562:	00001517          	auipc	a0,0x1
     566:	f2e50513          	addi	a0,a0,-210 # 1490 <malloc+0x1fc>
     56a:	00001097          	auipc	ra,0x1
     56e:	964080e7          	jalr	-1692(ra) # ece <chdir>
     572:	ed21                	bnez	a0,5ca <go+0x552>
      kill(pid);
     574:	855a                	mv	a0,s6
     576:	00001097          	auipc	ra,0x1
     57a:	918080e7          	jalr	-1768(ra) # e8e <kill>
      wait(0);
     57e:	4501                	li	a0,0
     580:	00001097          	auipc	ra,0x1
     584:	8e6080e7          	jalr	-1818(ra) # e66 <wait>
     588:	be69                	j	122 <go+0xaa>
        close(open("a", O_CREATE|O_RDWR));
     58a:	20200593          	li	a1,514
     58e:	00001517          	auipc	a0,0x1
     592:	eca50513          	addi	a0,a0,-310 # 1458 <malloc+0x1c4>
     596:	00001097          	auipc	ra,0x1
     59a:	908080e7          	jalr	-1784(ra) # e9e <open>
     59e:	00001097          	auipc	ra,0x1
     5a2:	8e8080e7          	jalr	-1816(ra) # e86 <close>
        exit(0);
     5a6:	4501                	li	a0,0
     5a8:	00001097          	auipc	ra,0x1
     5ac:	8b6080e7          	jalr	-1866(ra) # e5e <exit>
        printf("grind: fork failed\n");
     5b0:	00001517          	auipc	a0,0x1
     5b4:	ec850513          	addi	a0,a0,-312 # 1478 <malloc+0x1e4>
     5b8:	00001097          	auipc	ra,0x1
     5bc:	c1e080e7          	jalr	-994(ra) # 11d6 <printf>
        exit(1);
     5c0:	4505                	li	a0,1
     5c2:	00001097          	auipc	ra,0x1
     5c6:	89c080e7          	jalr	-1892(ra) # e5e <exit>
        printf("grind: chdir failed\n");
     5ca:	00001517          	auipc	a0,0x1
     5ce:	ed650513          	addi	a0,a0,-298 # 14a0 <malloc+0x20c>
     5d2:	00001097          	auipc	ra,0x1
     5d6:	c04080e7          	jalr	-1020(ra) # 11d6 <printf>
        exit(1);
     5da:	4505                	li	a0,1
     5dc:	00001097          	auipc	ra,0x1
     5e0:	882080e7          	jalr	-1918(ra) # e5e <exit>
      int pid = fork();
     5e4:	00001097          	auipc	ra,0x1
     5e8:	872080e7          	jalr	-1934(ra) # e56 <fork>
      if(pid == 0){
     5ec:	c909                	beqz	a0,5fe <go+0x586>
      } else if(pid < 0){
     5ee:	02054563          	bltz	a0,618 <go+0x5a0>
      wait(0);
     5f2:	4501                	li	a0,0
     5f4:	00001097          	auipc	ra,0x1
     5f8:	872080e7          	jalr	-1934(ra) # e66 <wait>
     5fc:	b61d                	j	122 <go+0xaa>
        kill(getpid());
     5fe:	00001097          	auipc	ra,0x1
     602:	8e0080e7          	jalr	-1824(ra) # ede <getpid>
     606:	00001097          	auipc	ra,0x1
     60a:	888080e7          	jalr	-1912(ra) # e8e <kill>
        exit(0);
     60e:	4501                	li	a0,0
     610:	00001097          	auipc	ra,0x1
     614:	84e080e7          	jalr	-1970(ra) # e5e <exit>
        printf("grind: fork failed\n");
     618:	00001517          	auipc	a0,0x1
     61c:	e6050513          	addi	a0,a0,-416 # 1478 <malloc+0x1e4>
     620:	00001097          	auipc	ra,0x1
     624:	bb6080e7          	jalr	-1098(ra) # 11d6 <printf>
        exit(1);
     628:	4505                	li	a0,1
     62a:	00001097          	auipc	ra,0x1
     62e:	834080e7          	jalr	-1996(ra) # e5e <exit>
      if(pipe(fds) < 0){
     632:	fa840513          	addi	a0,s0,-88
     636:	00001097          	auipc	ra,0x1
     63a:	838080e7          	jalr	-1992(ra) # e6e <pipe>
     63e:	02054b63          	bltz	a0,674 <go+0x5fc>
      int pid = fork();
     642:	00001097          	auipc	ra,0x1
     646:	814080e7          	jalr	-2028(ra) # e56 <fork>
      if(pid == 0){
     64a:	c131                	beqz	a0,68e <go+0x616>
      } else if(pid < 0){
     64c:	0a054a63          	bltz	a0,700 <go+0x688>
      close(fds[0]);
     650:	fa842503          	lw	a0,-88(s0)
     654:	00001097          	auipc	ra,0x1
     658:	832080e7          	jalr	-1998(ra) # e86 <close>
      close(fds[1]);
     65c:	fac42503          	lw	a0,-84(s0)
     660:	00001097          	auipc	ra,0x1
     664:	826080e7          	jalr	-2010(ra) # e86 <close>
      wait(0);
     668:	4501                	li	a0,0
     66a:	00000097          	auipc	ra,0x0
     66e:	7fc080e7          	jalr	2044(ra) # e66 <wait>
     672:	bc45                	j	122 <go+0xaa>
        printf("grind: pipe failed\n");
     674:	00001517          	auipc	a0,0x1
     678:	e4450513          	addi	a0,a0,-444 # 14b8 <malloc+0x224>
     67c:	00001097          	auipc	ra,0x1
     680:	b5a080e7          	jalr	-1190(ra) # 11d6 <printf>
        exit(1);
     684:	4505                	li	a0,1
     686:	00000097          	auipc	ra,0x0
     68a:	7d8080e7          	jalr	2008(ra) # e5e <exit>
        fork();
     68e:	00000097          	auipc	ra,0x0
     692:	7c8080e7          	jalr	1992(ra) # e56 <fork>
        fork();
     696:	00000097          	auipc	ra,0x0
     69a:	7c0080e7          	jalr	1984(ra) # e56 <fork>
        if(write(fds[1], "x", 1) != 1)
     69e:	4605                	li	a2,1
     6a0:	00001597          	auipc	a1,0x1
     6a4:	e3058593          	addi	a1,a1,-464 # 14d0 <malloc+0x23c>
     6a8:	fac42503          	lw	a0,-84(s0)
     6ac:	00000097          	auipc	ra,0x0
     6b0:	7d2080e7          	jalr	2002(ra) # e7e <write>
     6b4:	4785                	li	a5,1
     6b6:	02f51363          	bne	a0,a5,6dc <go+0x664>
        if(read(fds[0], &c, 1) != 1)
     6ba:	4605                	li	a2,1
     6bc:	fa040593          	addi	a1,s0,-96
     6c0:	fa842503          	lw	a0,-88(s0)
     6c4:	00000097          	auipc	ra,0x0
     6c8:	7b2080e7          	jalr	1970(ra) # e76 <read>
     6cc:	4785                	li	a5,1
     6ce:	02f51063          	bne	a0,a5,6ee <go+0x676>
        exit(0);
     6d2:	4501                	li	a0,0
     6d4:	00000097          	auipc	ra,0x0
     6d8:	78a080e7          	jalr	1930(ra) # e5e <exit>
          printf("grind: pipe write failed\n");
     6dc:	00001517          	auipc	a0,0x1
     6e0:	dfc50513          	addi	a0,a0,-516 # 14d8 <malloc+0x244>
     6e4:	00001097          	auipc	ra,0x1
     6e8:	af2080e7          	jalr	-1294(ra) # 11d6 <printf>
     6ec:	b7f9                	j	6ba <go+0x642>
          printf("grind: pipe read failed\n");
     6ee:	00001517          	auipc	a0,0x1
     6f2:	e0a50513          	addi	a0,a0,-502 # 14f8 <malloc+0x264>
     6f6:	00001097          	auipc	ra,0x1
     6fa:	ae0080e7          	jalr	-1312(ra) # 11d6 <printf>
     6fe:	bfd1                	j	6d2 <go+0x65a>
        printf("grind: fork failed\n");
     700:	00001517          	auipc	a0,0x1
     704:	d7850513          	addi	a0,a0,-648 # 1478 <malloc+0x1e4>
     708:	00001097          	auipc	ra,0x1
     70c:	ace080e7          	jalr	-1330(ra) # 11d6 <printf>
        exit(1);
     710:	4505                	li	a0,1
     712:	00000097          	auipc	ra,0x0
     716:	74c080e7          	jalr	1868(ra) # e5e <exit>
      int pid = fork();
     71a:	00000097          	auipc	ra,0x0
     71e:	73c080e7          	jalr	1852(ra) # e56 <fork>
      if(pid == 0){
     722:	c909                	beqz	a0,734 <go+0x6bc>
      } else if(pid < 0){
     724:	06054f63          	bltz	a0,7a2 <go+0x72a>
      wait(0);
     728:	4501                	li	a0,0
     72a:	00000097          	auipc	ra,0x0
     72e:	73c080e7          	jalr	1852(ra) # e66 <wait>
     732:	bac5                	j	122 <go+0xaa>
        unlink("a");
     734:	00001517          	auipc	a0,0x1
     738:	d2450513          	addi	a0,a0,-732 # 1458 <malloc+0x1c4>
     73c:	00000097          	auipc	ra,0x0
     740:	772080e7          	jalr	1906(ra) # eae <unlink>
        mkdir("a");
     744:	00001517          	auipc	a0,0x1
     748:	d1450513          	addi	a0,a0,-748 # 1458 <malloc+0x1c4>
     74c:	00000097          	auipc	ra,0x0
     750:	77a080e7          	jalr	1914(ra) # ec6 <mkdir>
        chdir("a");
     754:	00001517          	auipc	a0,0x1
     758:	d0450513          	addi	a0,a0,-764 # 1458 <malloc+0x1c4>
     75c:	00000097          	auipc	ra,0x0
     760:	772080e7          	jalr	1906(ra) # ece <chdir>
        unlink("../a");
     764:	00001517          	auipc	a0,0x1
     768:	c5c50513          	addi	a0,a0,-932 # 13c0 <malloc+0x12c>
     76c:	00000097          	auipc	ra,0x0
     770:	742080e7          	jalr	1858(ra) # eae <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     774:	20200593          	li	a1,514
     778:	00001517          	auipc	a0,0x1
     77c:	d5850513          	addi	a0,a0,-680 # 14d0 <malloc+0x23c>
     780:	00000097          	auipc	ra,0x0
     784:	71e080e7          	jalr	1822(ra) # e9e <open>
        unlink("x");
     788:	00001517          	auipc	a0,0x1
     78c:	d4850513          	addi	a0,a0,-696 # 14d0 <malloc+0x23c>
     790:	00000097          	auipc	ra,0x0
     794:	71e080e7          	jalr	1822(ra) # eae <unlink>
        exit(0);
     798:	4501                	li	a0,0
     79a:	00000097          	auipc	ra,0x0
     79e:	6c4080e7          	jalr	1732(ra) # e5e <exit>
        printf("grind: fork failed\n");
     7a2:	00001517          	auipc	a0,0x1
     7a6:	cd650513          	addi	a0,a0,-810 # 1478 <malloc+0x1e4>
     7aa:	00001097          	auipc	ra,0x1
     7ae:	a2c080e7          	jalr	-1492(ra) # 11d6 <printf>
        exit(1);
     7b2:	4505                	li	a0,1
     7b4:	00000097          	auipc	ra,0x0
     7b8:	6aa080e7          	jalr	1706(ra) # e5e <exit>
      unlink("c");
     7bc:	00001517          	auipc	a0,0x1
     7c0:	d5c50513          	addi	a0,a0,-676 # 1518 <malloc+0x284>
     7c4:	00000097          	auipc	ra,0x0
     7c8:	6ea080e7          	jalr	1770(ra) # eae <unlink>
      int fd1 = open("c", O_CREATE|O_RDWR);
     7cc:	20200593          	li	a1,514
     7d0:	00001517          	auipc	a0,0x1
     7d4:	d4850513          	addi	a0,a0,-696 # 1518 <malloc+0x284>
     7d8:	00000097          	auipc	ra,0x0
     7dc:	6c6080e7          	jalr	1734(ra) # e9e <open>
     7e0:	8b2a                	mv	s6,a0
      if(fd1 < 0){
     7e2:	04054f63          	bltz	a0,840 <go+0x7c8>
      if(write(fd1, "x", 1) != 1){
     7e6:	4605                	li	a2,1
     7e8:	00001597          	auipc	a1,0x1
     7ec:	ce858593          	addi	a1,a1,-792 # 14d0 <malloc+0x23c>
     7f0:	00000097          	auipc	ra,0x0
     7f4:	68e080e7          	jalr	1678(ra) # e7e <write>
     7f8:	4785                	li	a5,1
     7fa:	06f51063          	bne	a0,a5,85a <go+0x7e2>
      if(fstat(fd1, &st) != 0){
     7fe:	fa840593          	addi	a1,s0,-88
     802:	855a                	mv	a0,s6
     804:	00000097          	auipc	ra,0x0
     808:	6b2080e7          	jalr	1714(ra) # eb6 <fstat>
     80c:	e525                	bnez	a0,874 <go+0x7fc>
      if(st.size != 1){
     80e:	fb843583          	ld	a1,-72(s0)
     812:	4785                	li	a5,1
     814:	06f59d63          	bne	a1,a5,88e <go+0x816>
      if(st.ino > 200){
     818:	fac42583          	lw	a1,-84(s0)
     81c:	0c800793          	li	a5,200
     820:	08b7e563          	bltu	a5,a1,8aa <go+0x832>
      close(fd1);
     824:	855a                	mv	a0,s6
     826:	00000097          	auipc	ra,0x0
     82a:	660080e7          	jalr	1632(ra) # e86 <close>
      unlink("c");
     82e:	00001517          	auipc	a0,0x1
     832:	cea50513          	addi	a0,a0,-790 # 1518 <malloc+0x284>
     836:	00000097          	auipc	ra,0x0
     83a:	678080e7          	jalr	1656(ra) # eae <unlink>
     83e:	b0d5                	j	122 <go+0xaa>
        printf("grind: create c failed\n");
     840:	00001517          	auipc	a0,0x1
     844:	ce050513          	addi	a0,a0,-800 # 1520 <malloc+0x28c>
     848:	00001097          	auipc	ra,0x1
     84c:	98e080e7          	jalr	-1650(ra) # 11d6 <printf>
        exit(1);
     850:	4505                	li	a0,1
     852:	00000097          	auipc	ra,0x0
     856:	60c080e7          	jalr	1548(ra) # e5e <exit>
        printf("grind: write c failed\n");
     85a:	00001517          	auipc	a0,0x1
     85e:	cde50513          	addi	a0,a0,-802 # 1538 <malloc+0x2a4>
     862:	00001097          	auipc	ra,0x1
     866:	974080e7          	jalr	-1676(ra) # 11d6 <printf>
        exit(1);
     86a:	4505                	li	a0,1
     86c:	00000097          	auipc	ra,0x0
     870:	5f2080e7          	jalr	1522(ra) # e5e <exit>
        printf("grind: fstat failed\n");
     874:	00001517          	auipc	a0,0x1
     878:	cdc50513          	addi	a0,a0,-804 # 1550 <malloc+0x2bc>
     87c:	00001097          	auipc	ra,0x1
     880:	95a080e7          	jalr	-1702(ra) # 11d6 <printf>
        exit(1);
     884:	4505                	li	a0,1
     886:	00000097          	auipc	ra,0x0
     88a:	5d8080e7          	jalr	1496(ra) # e5e <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     88e:	2581                	sext.w	a1,a1
     890:	00001517          	auipc	a0,0x1
     894:	cd850513          	addi	a0,a0,-808 # 1568 <malloc+0x2d4>
     898:	00001097          	auipc	ra,0x1
     89c:	93e080e7          	jalr	-1730(ra) # 11d6 <printf>
        exit(1);
     8a0:	4505                	li	a0,1
     8a2:	00000097          	auipc	ra,0x0
     8a6:	5bc080e7          	jalr	1468(ra) # e5e <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     8aa:	00001517          	auipc	a0,0x1
     8ae:	ce650513          	addi	a0,a0,-794 # 1590 <malloc+0x2fc>
     8b2:	00001097          	auipc	ra,0x1
     8b6:	924080e7          	jalr	-1756(ra) # 11d6 <printf>
        exit(1);
     8ba:	4505                	li	a0,1
     8bc:	00000097          	auipc	ra,0x0
     8c0:	5a2080e7          	jalr	1442(ra) # e5e <exit>
        fprintf(2, "grind: pipe failed\n");
     8c4:	00001597          	auipc	a1,0x1
     8c8:	bf458593          	addi	a1,a1,-1036 # 14b8 <malloc+0x224>
     8cc:	4509                	li	a0,2
     8ce:	00001097          	auipc	ra,0x1
     8d2:	8da080e7          	jalr	-1830(ra) # 11a8 <fprintf>
        exit(1);
     8d6:	4505                	li	a0,1
     8d8:	00000097          	auipc	ra,0x0
     8dc:	586080e7          	jalr	1414(ra) # e5e <exit>
        fprintf(2, "grind: pipe failed\n");
     8e0:	00001597          	auipc	a1,0x1
     8e4:	bd858593          	addi	a1,a1,-1064 # 14b8 <malloc+0x224>
     8e8:	4509                	li	a0,2
     8ea:	00001097          	auipc	ra,0x1
     8ee:	8be080e7          	jalr	-1858(ra) # 11a8 <fprintf>
        exit(1);
     8f2:	4505                	li	a0,1
     8f4:	00000097          	auipc	ra,0x0
     8f8:	56a080e7          	jalr	1386(ra) # e5e <exit>
        close(bb[0]);
     8fc:	fa042503          	lw	a0,-96(s0)
     900:	00000097          	auipc	ra,0x0
     904:	586080e7          	jalr	1414(ra) # e86 <close>
        close(bb[1]);
     908:	fa442503          	lw	a0,-92(s0)
     90c:	00000097          	auipc	ra,0x0
     910:	57a080e7          	jalr	1402(ra) # e86 <close>
        close(aa[0]);
     914:	f9842503          	lw	a0,-104(s0)
     918:	00000097          	auipc	ra,0x0
     91c:	56e080e7          	jalr	1390(ra) # e86 <close>
        close(1);
     920:	4505                	li	a0,1
     922:	00000097          	auipc	ra,0x0
     926:	564080e7          	jalr	1380(ra) # e86 <close>
        if(dup(aa[1]) != 1){
     92a:	f9c42503          	lw	a0,-100(s0)
     92e:	00000097          	auipc	ra,0x0
     932:	5a8080e7          	jalr	1448(ra) # ed6 <dup>
     936:	4785                	li	a5,1
     938:	02f50063          	beq	a0,a5,958 <go+0x8e0>
          fprintf(2, "grind: dup failed\n");
     93c:	00001597          	auipc	a1,0x1
     940:	c7c58593          	addi	a1,a1,-900 # 15b8 <malloc+0x324>
     944:	4509                	li	a0,2
     946:	00001097          	auipc	ra,0x1
     94a:	862080e7          	jalr	-1950(ra) # 11a8 <fprintf>
          exit(1);
     94e:	4505                	li	a0,1
     950:	00000097          	auipc	ra,0x0
     954:	50e080e7          	jalr	1294(ra) # e5e <exit>
        close(aa[1]);
     958:	f9c42503          	lw	a0,-100(s0)
     95c:	00000097          	auipc	ra,0x0
     960:	52a080e7          	jalr	1322(ra) # e86 <close>
        char *args[3] = { "echo", "hi", 0 };
     964:	00001797          	auipc	a5,0x1
     968:	c6c78793          	addi	a5,a5,-916 # 15d0 <malloc+0x33c>
     96c:	faf43423          	sd	a5,-88(s0)
     970:	00001797          	auipc	a5,0x1
     974:	c6878793          	addi	a5,a5,-920 # 15d8 <malloc+0x344>
     978:	faf43823          	sd	a5,-80(s0)
     97c:	fa043c23          	sd	zero,-72(s0)
        exec("grindir/../echo", args);
     980:	fa840593          	addi	a1,s0,-88
     984:	00001517          	auipc	a0,0x1
     988:	c5c50513          	addi	a0,a0,-932 # 15e0 <malloc+0x34c>
     98c:	00000097          	auipc	ra,0x0
     990:	50a080e7          	jalr	1290(ra) # e96 <exec>
        fprintf(2, "grind: echo: not found\n");
     994:	00001597          	auipc	a1,0x1
     998:	c5c58593          	addi	a1,a1,-932 # 15f0 <malloc+0x35c>
     99c:	4509                	li	a0,2
     99e:	00001097          	auipc	ra,0x1
     9a2:	80a080e7          	jalr	-2038(ra) # 11a8 <fprintf>
        exit(2);
     9a6:	4509                	li	a0,2
     9a8:	00000097          	auipc	ra,0x0
     9ac:	4b6080e7          	jalr	1206(ra) # e5e <exit>
        fprintf(2, "grind: fork failed\n");
     9b0:	00001597          	auipc	a1,0x1
     9b4:	ac858593          	addi	a1,a1,-1336 # 1478 <malloc+0x1e4>
     9b8:	4509                	li	a0,2
     9ba:	00000097          	auipc	ra,0x0
     9be:	7ee080e7          	jalr	2030(ra) # 11a8 <fprintf>
        exit(3);
     9c2:	450d                	li	a0,3
     9c4:	00000097          	auipc	ra,0x0
     9c8:	49a080e7          	jalr	1178(ra) # e5e <exit>
        close(aa[1]);
     9cc:	f9c42503          	lw	a0,-100(s0)
     9d0:	00000097          	auipc	ra,0x0
     9d4:	4b6080e7          	jalr	1206(ra) # e86 <close>
        close(bb[0]);
     9d8:	fa042503          	lw	a0,-96(s0)
     9dc:	00000097          	auipc	ra,0x0
     9e0:	4aa080e7          	jalr	1194(ra) # e86 <close>
        close(0);
     9e4:	4501                	li	a0,0
     9e6:	00000097          	auipc	ra,0x0
     9ea:	4a0080e7          	jalr	1184(ra) # e86 <close>
        if(dup(aa[0]) != 0){
     9ee:	f9842503          	lw	a0,-104(s0)
     9f2:	00000097          	auipc	ra,0x0
     9f6:	4e4080e7          	jalr	1252(ra) # ed6 <dup>
     9fa:	cd19                	beqz	a0,a18 <go+0x9a0>
          fprintf(2, "grind: dup failed\n");
     9fc:	00001597          	auipc	a1,0x1
     a00:	bbc58593          	addi	a1,a1,-1092 # 15b8 <malloc+0x324>
     a04:	4509                	li	a0,2
     a06:	00000097          	auipc	ra,0x0
     a0a:	7a2080e7          	jalr	1954(ra) # 11a8 <fprintf>
          exit(4);
     a0e:	4511                	li	a0,4
     a10:	00000097          	auipc	ra,0x0
     a14:	44e080e7          	jalr	1102(ra) # e5e <exit>
        close(aa[0]);
     a18:	f9842503          	lw	a0,-104(s0)
     a1c:	00000097          	auipc	ra,0x0
     a20:	46a080e7          	jalr	1130(ra) # e86 <close>
        close(1);
     a24:	4505                	li	a0,1
     a26:	00000097          	auipc	ra,0x0
     a2a:	460080e7          	jalr	1120(ra) # e86 <close>
        if(dup(bb[1]) != 1){
     a2e:	fa442503          	lw	a0,-92(s0)
     a32:	00000097          	auipc	ra,0x0
     a36:	4a4080e7          	jalr	1188(ra) # ed6 <dup>
     a3a:	4785                	li	a5,1
     a3c:	02f50063          	beq	a0,a5,a5c <go+0x9e4>
          fprintf(2, "grind: dup failed\n");
     a40:	00001597          	auipc	a1,0x1
     a44:	b7858593          	addi	a1,a1,-1160 # 15b8 <malloc+0x324>
     a48:	4509                	li	a0,2
     a4a:	00000097          	auipc	ra,0x0
     a4e:	75e080e7          	jalr	1886(ra) # 11a8 <fprintf>
          exit(5);
     a52:	4515                	li	a0,5
     a54:	00000097          	auipc	ra,0x0
     a58:	40a080e7          	jalr	1034(ra) # e5e <exit>
        close(bb[1]);
     a5c:	fa442503          	lw	a0,-92(s0)
     a60:	00000097          	auipc	ra,0x0
     a64:	426080e7          	jalr	1062(ra) # e86 <close>
        char *args[2] = { "cat", 0 };
     a68:	00001797          	auipc	a5,0x1
     a6c:	ba078793          	addi	a5,a5,-1120 # 1608 <malloc+0x374>
     a70:	faf43423          	sd	a5,-88(s0)
     a74:	fa043823          	sd	zero,-80(s0)
        exec("/cat", args);
     a78:	fa840593          	addi	a1,s0,-88
     a7c:	00001517          	auipc	a0,0x1
     a80:	b9450513          	addi	a0,a0,-1132 # 1610 <malloc+0x37c>
     a84:	00000097          	auipc	ra,0x0
     a88:	412080e7          	jalr	1042(ra) # e96 <exec>
        fprintf(2, "grind: cat: not found\n");
     a8c:	00001597          	auipc	a1,0x1
     a90:	b8c58593          	addi	a1,a1,-1140 # 1618 <malloc+0x384>
     a94:	4509                	li	a0,2
     a96:	00000097          	auipc	ra,0x0
     a9a:	712080e7          	jalr	1810(ra) # 11a8 <fprintf>
        exit(6);
     a9e:	4519                	li	a0,6
     aa0:	00000097          	auipc	ra,0x0
     aa4:	3be080e7          	jalr	958(ra) # e5e <exit>
        fprintf(2, "grind: fork failed\n");
     aa8:	00001597          	auipc	a1,0x1
     aac:	9d058593          	addi	a1,a1,-1584 # 1478 <malloc+0x1e4>
     ab0:	4509                	li	a0,2
     ab2:	00000097          	auipc	ra,0x0
     ab6:	6f6080e7          	jalr	1782(ra) # 11a8 <fprintf>
        exit(7);
     aba:	451d                	li	a0,7
     abc:	00000097          	auipc	ra,0x0
     ac0:	3a2080e7          	jalr	930(ra) # e5e <exit>

0000000000000ac4 <iter>:
  }
}

void
iter()
{
     ac4:	7179                	addi	sp,sp,-48
     ac6:	f406                	sd	ra,40(sp)
     ac8:	f022                	sd	s0,32(sp)
     aca:	ec26                	sd	s1,24(sp)
     acc:	e84a                	sd	s2,16(sp)
     ace:	1800                	addi	s0,sp,48
  unlink("a");
     ad0:	00001517          	auipc	a0,0x1
     ad4:	98850513          	addi	a0,a0,-1656 # 1458 <malloc+0x1c4>
     ad8:	00000097          	auipc	ra,0x0
     adc:	3d6080e7          	jalr	982(ra) # eae <unlink>
  unlink("b");
     ae0:	00001517          	auipc	a0,0x1
     ae4:	92850513          	addi	a0,a0,-1752 # 1408 <malloc+0x174>
     ae8:	00000097          	auipc	ra,0x0
     aec:	3c6080e7          	jalr	966(ra) # eae <unlink>
  
  int pid1 = fork();
     af0:	00000097          	auipc	ra,0x0
     af4:	366080e7          	jalr	870(ra) # e56 <fork>
  if(pid1 < 0){
     af8:	00054e63          	bltz	a0,b14 <iter+0x50>
     afc:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     afe:	e905                	bnez	a0,b2e <iter+0x6a>
    rand_next = 31;
     b00:	47fd                	li	a5,31
     b02:	00001717          	auipc	a4,0x1
     b06:	b6f73f23          	sd	a5,-1154(a4) # 1680 <rand_next>
    go(0);
     b0a:	4501                	li	a0,0
     b0c:	fffff097          	auipc	ra,0xfffff
     b10:	56c080e7          	jalr	1388(ra) # 78 <go>
    printf("grind: fork failed\n");
     b14:	00001517          	auipc	a0,0x1
     b18:	96450513          	addi	a0,a0,-1692 # 1478 <malloc+0x1e4>
     b1c:	00000097          	auipc	ra,0x0
     b20:	6ba080e7          	jalr	1722(ra) # 11d6 <printf>
    exit(1);
     b24:	4505                	li	a0,1
     b26:	00000097          	auipc	ra,0x0
     b2a:	338080e7          	jalr	824(ra) # e5e <exit>
    exit(0);
  }

  int pid2 = fork();
     b2e:	00000097          	auipc	ra,0x0
     b32:	328080e7          	jalr	808(ra) # e56 <fork>
     b36:	892a                	mv	s2,a0
  if(pid2 < 0){
     b38:	00054f63          	bltz	a0,b56 <iter+0x92>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     b3c:	e915                	bnez	a0,b70 <iter+0xac>
    rand_next = 7177;
     b3e:	6789                	lui	a5,0x2
     b40:	c0978793          	addi	a5,a5,-1015 # 1c09 <__BSS_END__+0x181>
     b44:	00001717          	auipc	a4,0x1
     b48:	b2f73e23          	sd	a5,-1220(a4) # 1680 <rand_next>
    go(1);
     b4c:	4505                	li	a0,1
     b4e:	fffff097          	auipc	ra,0xfffff
     b52:	52a080e7          	jalr	1322(ra) # 78 <go>
    printf("grind: fork failed\n");
     b56:	00001517          	auipc	a0,0x1
     b5a:	92250513          	addi	a0,a0,-1758 # 1478 <malloc+0x1e4>
     b5e:	00000097          	auipc	ra,0x0
     b62:	678080e7          	jalr	1656(ra) # 11d6 <printf>
    exit(1);
     b66:	4505                	li	a0,1
     b68:	00000097          	auipc	ra,0x0
     b6c:	2f6080e7          	jalr	758(ra) # e5e <exit>
    exit(0);
  }

  int st1 = -1;
     b70:	57fd                	li	a5,-1
     b72:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     b76:	fdc40513          	addi	a0,s0,-36
     b7a:	00000097          	auipc	ra,0x0
     b7e:	2ec080e7          	jalr	748(ra) # e66 <wait>
  if(st1 != 0){
     b82:	fdc42783          	lw	a5,-36(s0)
     b86:	ef99                	bnez	a5,ba4 <iter+0xe0>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     b88:	57fd                	li	a5,-1
     b8a:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     b8e:	fd840513          	addi	a0,s0,-40
     b92:	00000097          	auipc	ra,0x0
     b96:	2d4080e7          	jalr	724(ra) # e66 <wait>

  exit(0);
     b9a:	4501                	li	a0,0
     b9c:	00000097          	auipc	ra,0x0
     ba0:	2c2080e7          	jalr	706(ra) # e5e <exit>
    kill(pid1);
     ba4:	8526                	mv	a0,s1
     ba6:	00000097          	auipc	ra,0x0
     baa:	2e8080e7          	jalr	744(ra) # e8e <kill>
    kill(pid2);
     bae:	854a                	mv	a0,s2
     bb0:	00000097          	auipc	ra,0x0
     bb4:	2de080e7          	jalr	734(ra) # e8e <kill>
     bb8:	bfc1                	j	b88 <iter+0xc4>

0000000000000bba <main>:
}

int
main()
{
     bba:	1141                	addi	sp,sp,-16
     bbc:	e406                	sd	ra,8(sp)
     bbe:	e022                	sd	s0,0(sp)
     bc0:	0800                	addi	s0,sp,16
     bc2:	a811                	j	bd6 <main+0x1c>
  while(1){
    int pid = fork();
    if(pid == 0){
      iter();
     bc4:	00000097          	auipc	ra,0x0
     bc8:	f00080e7          	jalr	-256(ra) # ac4 <iter>
      exit(0);
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
     bcc:	4551                	li	a0,20
     bce:	00000097          	auipc	ra,0x0
     bd2:	320080e7          	jalr	800(ra) # eee <sleep>
    int pid = fork();
     bd6:	00000097          	auipc	ra,0x0
     bda:	280080e7          	jalr	640(ra) # e56 <fork>
    if(pid == 0){
     bde:	d17d                	beqz	a0,bc4 <main+0xa>
    if(pid > 0){
     be0:	fea056e3          	blez	a0,bcc <main+0x12>
      wait(0);
     be4:	4501                	li	a0,0
     be6:	00000097          	auipc	ra,0x0
     bea:	280080e7          	jalr	640(ra) # e66 <wait>
     bee:	bff9                	j	bcc <main+0x12>

0000000000000bf0 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     bf0:	1141                	addi	sp,sp,-16
     bf2:	e422                	sd	s0,8(sp)
     bf4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     bf6:	87aa                	mv	a5,a0
     bf8:	0585                	addi	a1,a1,1
     bfa:	0785                	addi	a5,a5,1
     bfc:	fff5c703          	lbu	a4,-1(a1)
     c00:	fee78fa3          	sb	a4,-1(a5)
     c04:	fb75                	bnez	a4,bf8 <strcpy+0x8>
    ;
  return os;
}
     c06:	6422                	ld	s0,8(sp)
     c08:	0141                	addi	sp,sp,16
     c0a:	8082                	ret

0000000000000c0c <strcmp>:

int
strcmp(const char *p, const char *q)
{
     c0c:	1141                	addi	sp,sp,-16
     c0e:	e422                	sd	s0,8(sp)
     c10:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     c12:	00054783          	lbu	a5,0(a0)
     c16:	cb91                	beqz	a5,c2a <strcmp+0x1e>
     c18:	0005c703          	lbu	a4,0(a1)
     c1c:	00f71763          	bne	a4,a5,c2a <strcmp+0x1e>
    p++, q++;
     c20:	0505                	addi	a0,a0,1
     c22:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     c24:	00054783          	lbu	a5,0(a0)
     c28:	fbe5                	bnez	a5,c18 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     c2a:	0005c503          	lbu	a0,0(a1)
}
     c2e:	40a7853b          	subw	a0,a5,a0
     c32:	6422                	ld	s0,8(sp)
     c34:	0141                	addi	sp,sp,16
     c36:	8082                	ret

0000000000000c38 <strlen>:

uint
strlen(const char *s)
{
     c38:	1141                	addi	sp,sp,-16
     c3a:	e422                	sd	s0,8(sp)
     c3c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     c3e:	00054783          	lbu	a5,0(a0)
     c42:	cf91                	beqz	a5,c5e <strlen+0x26>
     c44:	0505                	addi	a0,a0,1
     c46:	87aa                	mv	a5,a0
     c48:	4685                	li	a3,1
     c4a:	9e89                	subw	a3,a3,a0
     c4c:	00f6853b          	addw	a0,a3,a5
     c50:	0785                	addi	a5,a5,1
     c52:	fff7c703          	lbu	a4,-1(a5)
     c56:	fb7d                	bnez	a4,c4c <strlen+0x14>
    ;
  return n;
}
     c58:	6422                	ld	s0,8(sp)
     c5a:	0141                	addi	sp,sp,16
     c5c:	8082                	ret
  for(n = 0; s[n]; n++)
     c5e:	4501                	li	a0,0
     c60:	bfe5                	j	c58 <strlen+0x20>

0000000000000c62 <memset>:

void*
memset(void *dst, int c, uint n)
{
     c62:	1141                	addi	sp,sp,-16
     c64:	e422                	sd	s0,8(sp)
     c66:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     c68:	ca19                	beqz	a2,c7e <memset+0x1c>
     c6a:	87aa                	mv	a5,a0
     c6c:	1602                	slli	a2,a2,0x20
     c6e:	9201                	srli	a2,a2,0x20
     c70:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     c74:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c78:	0785                	addi	a5,a5,1
     c7a:	fee79de3          	bne	a5,a4,c74 <memset+0x12>
  }
  return dst;
}
     c7e:	6422                	ld	s0,8(sp)
     c80:	0141                	addi	sp,sp,16
     c82:	8082                	ret

0000000000000c84 <strchr>:

char*
strchr(const char *s, char c)
{
     c84:	1141                	addi	sp,sp,-16
     c86:	e422                	sd	s0,8(sp)
     c88:	0800                	addi	s0,sp,16
  for(; *s; s++)
     c8a:	00054783          	lbu	a5,0(a0)
     c8e:	cb99                	beqz	a5,ca4 <strchr+0x20>
    if(*s == c)
     c90:	00f58763          	beq	a1,a5,c9e <strchr+0x1a>
  for(; *s; s++)
     c94:	0505                	addi	a0,a0,1
     c96:	00054783          	lbu	a5,0(a0)
     c9a:	fbfd                	bnez	a5,c90 <strchr+0xc>
      return (char*)s;
  return 0;
     c9c:	4501                	li	a0,0
}
     c9e:	6422                	ld	s0,8(sp)
     ca0:	0141                	addi	sp,sp,16
     ca2:	8082                	ret
  return 0;
     ca4:	4501                	li	a0,0
     ca6:	bfe5                	j	c9e <strchr+0x1a>

0000000000000ca8 <gets>:

char*
gets(char *buf, int max)
{
     ca8:	711d                	addi	sp,sp,-96
     caa:	ec86                	sd	ra,88(sp)
     cac:	e8a2                	sd	s0,80(sp)
     cae:	e4a6                	sd	s1,72(sp)
     cb0:	e0ca                	sd	s2,64(sp)
     cb2:	fc4e                	sd	s3,56(sp)
     cb4:	f852                	sd	s4,48(sp)
     cb6:	f456                	sd	s5,40(sp)
     cb8:	f05a                	sd	s6,32(sp)
     cba:	ec5e                	sd	s7,24(sp)
     cbc:	1080                	addi	s0,sp,96
     cbe:	8baa                	mv	s7,a0
     cc0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     cc2:	892a                	mv	s2,a0
     cc4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     cc6:	4aa9                	li	s5,10
     cc8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     cca:	89a6                	mv	s3,s1
     ccc:	2485                	addiw	s1,s1,1
     cce:	0344d863          	bge	s1,s4,cfe <gets+0x56>
    cc = read(0, &c, 1);
     cd2:	4605                	li	a2,1
     cd4:	faf40593          	addi	a1,s0,-81
     cd8:	4501                	li	a0,0
     cda:	00000097          	auipc	ra,0x0
     cde:	19c080e7          	jalr	412(ra) # e76 <read>
    if(cc < 1)
     ce2:	00a05e63          	blez	a0,cfe <gets+0x56>
    buf[i++] = c;
     ce6:	faf44783          	lbu	a5,-81(s0)
     cea:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     cee:	01578763          	beq	a5,s5,cfc <gets+0x54>
     cf2:	0905                	addi	s2,s2,1
     cf4:	fd679be3          	bne	a5,s6,cca <gets+0x22>
  for(i=0; i+1 < max; ){
     cf8:	89a6                	mv	s3,s1
     cfa:	a011                	j	cfe <gets+0x56>
     cfc:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     cfe:	99de                	add	s3,s3,s7
     d00:	00098023          	sb	zero,0(s3)
  return buf;
}
     d04:	855e                	mv	a0,s7
     d06:	60e6                	ld	ra,88(sp)
     d08:	6446                	ld	s0,80(sp)
     d0a:	64a6                	ld	s1,72(sp)
     d0c:	6906                	ld	s2,64(sp)
     d0e:	79e2                	ld	s3,56(sp)
     d10:	7a42                	ld	s4,48(sp)
     d12:	7aa2                	ld	s5,40(sp)
     d14:	7b02                	ld	s6,32(sp)
     d16:	6be2                	ld	s7,24(sp)
     d18:	6125                	addi	sp,sp,96
     d1a:	8082                	ret

0000000000000d1c <stat>:

int
stat(const char *n, struct stat *st)
{
     d1c:	1101                	addi	sp,sp,-32
     d1e:	ec06                	sd	ra,24(sp)
     d20:	e822                	sd	s0,16(sp)
     d22:	e426                	sd	s1,8(sp)
     d24:	e04a                	sd	s2,0(sp)
     d26:	1000                	addi	s0,sp,32
     d28:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d2a:	4581                	li	a1,0
     d2c:	00000097          	auipc	ra,0x0
     d30:	172080e7          	jalr	370(ra) # e9e <open>
  if(fd < 0)
     d34:	02054563          	bltz	a0,d5e <stat+0x42>
     d38:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     d3a:	85ca                	mv	a1,s2
     d3c:	00000097          	auipc	ra,0x0
     d40:	17a080e7          	jalr	378(ra) # eb6 <fstat>
     d44:	892a                	mv	s2,a0
  close(fd);
     d46:	8526                	mv	a0,s1
     d48:	00000097          	auipc	ra,0x0
     d4c:	13e080e7          	jalr	318(ra) # e86 <close>
  return r;
}
     d50:	854a                	mv	a0,s2
     d52:	60e2                	ld	ra,24(sp)
     d54:	6442                	ld	s0,16(sp)
     d56:	64a2                	ld	s1,8(sp)
     d58:	6902                	ld	s2,0(sp)
     d5a:	6105                	addi	sp,sp,32
     d5c:	8082                	ret
    return -1;
     d5e:	597d                	li	s2,-1
     d60:	bfc5                	j	d50 <stat+0x34>

0000000000000d62 <atoi>:

int
atoi(const char *s)
{
     d62:	1141                	addi	sp,sp,-16
     d64:	e422                	sd	s0,8(sp)
     d66:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d68:	00054603          	lbu	a2,0(a0)
     d6c:	fd06079b          	addiw	a5,a2,-48
     d70:	0ff7f793          	andi	a5,a5,255
     d74:	4725                	li	a4,9
     d76:	02f76963          	bltu	a4,a5,da8 <atoi+0x46>
     d7a:	86aa                	mv	a3,a0
  n = 0;
     d7c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     d7e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     d80:	0685                	addi	a3,a3,1
     d82:	0025179b          	slliw	a5,a0,0x2
     d86:	9fa9                	addw	a5,a5,a0
     d88:	0017979b          	slliw	a5,a5,0x1
     d8c:	9fb1                	addw	a5,a5,a2
     d8e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     d92:	0006c603          	lbu	a2,0(a3)
     d96:	fd06071b          	addiw	a4,a2,-48
     d9a:	0ff77713          	andi	a4,a4,255
     d9e:	fee5f1e3          	bgeu	a1,a4,d80 <atoi+0x1e>
  return n;
}
     da2:	6422                	ld	s0,8(sp)
     da4:	0141                	addi	sp,sp,16
     da6:	8082                	ret
  n = 0;
     da8:	4501                	li	a0,0
     daa:	bfe5                	j	da2 <atoi+0x40>

0000000000000dac <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     dac:	1141                	addi	sp,sp,-16
     dae:	e422                	sd	s0,8(sp)
     db0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     db2:	02b57463          	bgeu	a0,a1,dda <memmove+0x2e>
    while(n-- > 0)
     db6:	00c05f63          	blez	a2,dd4 <memmove+0x28>
     dba:	1602                	slli	a2,a2,0x20
     dbc:	9201                	srli	a2,a2,0x20
     dbe:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     dc2:	872a                	mv	a4,a0
      *dst++ = *src++;
     dc4:	0585                	addi	a1,a1,1
     dc6:	0705                	addi	a4,a4,1
     dc8:	fff5c683          	lbu	a3,-1(a1)
     dcc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     dd0:	fee79ae3          	bne	a5,a4,dc4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     dd4:	6422                	ld	s0,8(sp)
     dd6:	0141                	addi	sp,sp,16
     dd8:	8082                	ret
    dst += n;
     dda:	00c50733          	add	a4,a0,a2
    src += n;
     dde:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     de0:	fec05ae3          	blez	a2,dd4 <memmove+0x28>
     de4:	fff6079b          	addiw	a5,a2,-1
     de8:	1782                	slli	a5,a5,0x20
     dea:	9381                	srli	a5,a5,0x20
     dec:	fff7c793          	not	a5,a5
     df0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     df2:	15fd                	addi	a1,a1,-1
     df4:	177d                	addi	a4,a4,-1
     df6:	0005c683          	lbu	a3,0(a1)
     dfa:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     dfe:	fee79ae3          	bne	a5,a4,df2 <memmove+0x46>
     e02:	bfc9                	j	dd4 <memmove+0x28>

0000000000000e04 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     e04:	1141                	addi	sp,sp,-16
     e06:	e422                	sd	s0,8(sp)
     e08:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     e0a:	ca05                	beqz	a2,e3a <memcmp+0x36>
     e0c:	fff6069b          	addiw	a3,a2,-1
     e10:	1682                	slli	a3,a3,0x20
     e12:	9281                	srli	a3,a3,0x20
     e14:	0685                	addi	a3,a3,1
     e16:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     e18:	00054783          	lbu	a5,0(a0)
     e1c:	0005c703          	lbu	a4,0(a1)
     e20:	00e79863          	bne	a5,a4,e30 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     e24:	0505                	addi	a0,a0,1
    p2++;
     e26:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     e28:	fed518e3          	bne	a0,a3,e18 <memcmp+0x14>
  }
  return 0;
     e2c:	4501                	li	a0,0
     e2e:	a019                	j	e34 <memcmp+0x30>
      return *p1 - *p2;
     e30:	40e7853b          	subw	a0,a5,a4
}
     e34:	6422                	ld	s0,8(sp)
     e36:	0141                	addi	sp,sp,16
     e38:	8082                	ret
  return 0;
     e3a:	4501                	li	a0,0
     e3c:	bfe5                	j	e34 <memcmp+0x30>

0000000000000e3e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     e3e:	1141                	addi	sp,sp,-16
     e40:	e406                	sd	ra,8(sp)
     e42:	e022                	sd	s0,0(sp)
     e44:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     e46:	00000097          	auipc	ra,0x0
     e4a:	f66080e7          	jalr	-154(ra) # dac <memmove>
}
     e4e:	60a2                	ld	ra,8(sp)
     e50:	6402                	ld	s0,0(sp)
     e52:	0141                	addi	sp,sp,16
     e54:	8082                	ret

0000000000000e56 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     e56:	4885                	li	a7,1
 ecall
     e58:	00000073          	ecall
 ret
     e5c:	8082                	ret

0000000000000e5e <exit>:
.global exit
exit:
 li a7, SYS_exit
     e5e:	4889                	li	a7,2
 ecall
     e60:	00000073          	ecall
 ret
     e64:	8082                	ret

0000000000000e66 <wait>:
.global wait
wait:
 li a7, SYS_wait
     e66:	488d                	li	a7,3
 ecall
     e68:	00000073          	ecall
 ret
     e6c:	8082                	ret

0000000000000e6e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e6e:	4891                	li	a7,4
 ecall
     e70:	00000073          	ecall
 ret
     e74:	8082                	ret

0000000000000e76 <read>:
.global read
read:
 li a7, SYS_read
     e76:	4895                	li	a7,5
 ecall
     e78:	00000073          	ecall
 ret
     e7c:	8082                	ret

0000000000000e7e <write>:
.global write
write:
 li a7, SYS_write
     e7e:	48c1                	li	a7,16
 ecall
     e80:	00000073          	ecall
 ret
     e84:	8082                	ret

0000000000000e86 <close>:
.global close
close:
 li a7, SYS_close
     e86:	48d5                	li	a7,21
 ecall
     e88:	00000073          	ecall
 ret
     e8c:	8082                	ret

0000000000000e8e <kill>:
.global kill
kill:
 li a7, SYS_kill
     e8e:	4899                	li	a7,6
 ecall
     e90:	00000073          	ecall
 ret
     e94:	8082                	ret

0000000000000e96 <exec>:
.global exec
exec:
 li a7, SYS_exec
     e96:	489d                	li	a7,7
 ecall
     e98:	00000073          	ecall
 ret
     e9c:	8082                	ret

0000000000000e9e <open>:
.global open
open:
 li a7, SYS_open
     e9e:	48bd                	li	a7,15
 ecall
     ea0:	00000073          	ecall
 ret
     ea4:	8082                	ret

0000000000000ea6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     ea6:	48c5                	li	a7,17
 ecall
     ea8:	00000073          	ecall
 ret
     eac:	8082                	ret

0000000000000eae <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     eae:	48c9                	li	a7,18
 ecall
     eb0:	00000073          	ecall
 ret
     eb4:	8082                	ret

0000000000000eb6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     eb6:	48a1                	li	a7,8
 ecall
     eb8:	00000073          	ecall
 ret
     ebc:	8082                	ret

0000000000000ebe <link>:
.global link
link:
 li a7, SYS_link
     ebe:	48cd                	li	a7,19
 ecall
     ec0:	00000073          	ecall
 ret
     ec4:	8082                	ret

0000000000000ec6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     ec6:	48d1                	li	a7,20
 ecall
     ec8:	00000073          	ecall
 ret
     ecc:	8082                	ret

0000000000000ece <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     ece:	48a5                	li	a7,9
 ecall
     ed0:	00000073          	ecall
 ret
     ed4:	8082                	ret

0000000000000ed6 <dup>:
.global dup
dup:
 li a7, SYS_dup
     ed6:	48a9                	li	a7,10
 ecall
     ed8:	00000073          	ecall
 ret
     edc:	8082                	ret

0000000000000ede <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     ede:	48ad                	li	a7,11
 ecall
     ee0:	00000073          	ecall
 ret
     ee4:	8082                	ret

0000000000000ee6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     ee6:	48b1                	li	a7,12
 ecall
     ee8:	00000073          	ecall
 ret
     eec:	8082                	ret

0000000000000eee <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     eee:	48b5                	li	a7,13
 ecall
     ef0:	00000073          	ecall
 ret
     ef4:	8082                	ret

0000000000000ef6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     ef6:	48b9                	li	a7,14
 ecall
     ef8:	00000073          	ecall
 ret
     efc:	8082                	ret

0000000000000efe <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     efe:	1101                	addi	sp,sp,-32
     f00:	ec06                	sd	ra,24(sp)
     f02:	e822                	sd	s0,16(sp)
     f04:	1000                	addi	s0,sp,32
     f06:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     f0a:	4605                	li	a2,1
     f0c:	fef40593          	addi	a1,s0,-17
     f10:	00000097          	auipc	ra,0x0
     f14:	f6e080e7          	jalr	-146(ra) # e7e <write>
}
     f18:	60e2                	ld	ra,24(sp)
     f1a:	6442                	ld	s0,16(sp)
     f1c:	6105                	addi	sp,sp,32
     f1e:	8082                	ret

0000000000000f20 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     f20:	7139                	addi	sp,sp,-64
     f22:	fc06                	sd	ra,56(sp)
     f24:	f822                	sd	s0,48(sp)
     f26:	f426                	sd	s1,40(sp)
     f28:	f04a                	sd	s2,32(sp)
     f2a:	ec4e                	sd	s3,24(sp)
     f2c:	0080                	addi	s0,sp,64
     f2e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     f30:	c299                	beqz	a3,f36 <printint+0x16>
     f32:	0805c863          	bltz	a1,fc2 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     f36:	2581                	sext.w	a1,a1
  neg = 0;
     f38:	4881                	li	a7,0
     f3a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     f3e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     f40:	2601                	sext.w	a2,a2
     f42:	00000517          	auipc	a0,0x0
     f46:	72650513          	addi	a0,a0,1830 # 1668 <digits>
     f4a:	883a                	mv	a6,a4
     f4c:	2705                	addiw	a4,a4,1
     f4e:	02c5f7bb          	remuw	a5,a1,a2
     f52:	1782                	slli	a5,a5,0x20
     f54:	9381                	srli	a5,a5,0x20
     f56:	97aa                	add	a5,a5,a0
     f58:	0007c783          	lbu	a5,0(a5)
     f5c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     f60:	0005879b          	sext.w	a5,a1
     f64:	02c5d5bb          	divuw	a1,a1,a2
     f68:	0685                	addi	a3,a3,1
     f6a:	fec7f0e3          	bgeu	a5,a2,f4a <printint+0x2a>
  if(neg)
     f6e:	00088b63          	beqz	a7,f84 <printint+0x64>
    buf[i++] = '-';
     f72:	fd040793          	addi	a5,s0,-48
     f76:	973e                	add	a4,a4,a5
     f78:	02d00793          	li	a5,45
     f7c:	fef70823          	sb	a5,-16(a4)
     f80:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     f84:	02e05863          	blez	a4,fb4 <printint+0x94>
     f88:	fc040793          	addi	a5,s0,-64
     f8c:	00e78933          	add	s2,a5,a4
     f90:	fff78993          	addi	s3,a5,-1
     f94:	99ba                	add	s3,s3,a4
     f96:	377d                	addiw	a4,a4,-1
     f98:	1702                	slli	a4,a4,0x20
     f9a:	9301                	srli	a4,a4,0x20
     f9c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     fa0:	fff94583          	lbu	a1,-1(s2)
     fa4:	8526                	mv	a0,s1
     fa6:	00000097          	auipc	ra,0x0
     faa:	f58080e7          	jalr	-168(ra) # efe <putc>
  while(--i >= 0)
     fae:	197d                	addi	s2,s2,-1
     fb0:	ff3918e3          	bne	s2,s3,fa0 <printint+0x80>
}
     fb4:	70e2                	ld	ra,56(sp)
     fb6:	7442                	ld	s0,48(sp)
     fb8:	74a2                	ld	s1,40(sp)
     fba:	7902                	ld	s2,32(sp)
     fbc:	69e2                	ld	s3,24(sp)
     fbe:	6121                	addi	sp,sp,64
     fc0:	8082                	ret
    x = -xx;
     fc2:	40b005bb          	negw	a1,a1
    neg = 1;
     fc6:	4885                	li	a7,1
    x = -xx;
     fc8:	bf8d                	j	f3a <printint+0x1a>

0000000000000fca <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     fca:	7119                	addi	sp,sp,-128
     fcc:	fc86                	sd	ra,120(sp)
     fce:	f8a2                	sd	s0,112(sp)
     fd0:	f4a6                	sd	s1,104(sp)
     fd2:	f0ca                	sd	s2,96(sp)
     fd4:	ecce                	sd	s3,88(sp)
     fd6:	e8d2                	sd	s4,80(sp)
     fd8:	e4d6                	sd	s5,72(sp)
     fda:	e0da                	sd	s6,64(sp)
     fdc:	fc5e                	sd	s7,56(sp)
     fde:	f862                	sd	s8,48(sp)
     fe0:	f466                	sd	s9,40(sp)
     fe2:	f06a                	sd	s10,32(sp)
     fe4:	ec6e                	sd	s11,24(sp)
     fe6:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     fe8:	0005c903          	lbu	s2,0(a1)
     fec:	18090f63          	beqz	s2,118a <vprintf+0x1c0>
     ff0:	8aaa                	mv	s5,a0
     ff2:	8b32                	mv	s6,a2
     ff4:	00158493          	addi	s1,a1,1
  state = 0;
     ff8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     ffa:	02500a13          	li	s4,37
      if(c == 'd'){
     ffe:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    1002:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    1006:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    100a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    100e:	00000b97          	auipc	s7,0x0
    1012:	65ab8b93          	addi	s7,s7,1626 # 1668 <digits>
    1016:	a839                	j	1034 <vprintf+0x6a>
        putc(fd, c);
    1018:	85ca                	mv	a1,s2
    101a:	8556                	mv	a0,s5
    101c:	00000097          	auipc	ra,0x0
    1020:	ee2080e7          	jalr	-286(ra) # efe <putc>
    1024:	a019                	j	102a <vprintf+0x60>
    } else if(state == '%'){
    1026:	01498f63          	beq	s3,s4,1044 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    102a:	0485                	addi	s1,s1,1
    102c:	fff4c903          	lbu	s2,-1(s1)
    1030:	14090d63          	beqz	s2,118a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    1034:	0009079b          	sext.w	a5,s2
    if(state == 0){
    1038:	fe0997e3          	bnez	s3,1026 <vprintf+0x5c>
      if(c == '%'){
    103c:	fd479ee3          	bne	a5,s4,1018 <vprintf+0x4e>
        state = '%';
    1040:	89be                	mv	s3,a5
    1042:	b7e5                	j	102a <vprintf+0x60>
      if(c == 'd'){
    1044:	05878063          	beq	a5,s8,1084 <vprintf+0xba>
      } else if(c == 'l') {
    1048:	05978c63          	beq	a5,s9,10a0 <vprintf+0xd6>
      } else if(c == 'x') {
    104c:	07a78863          	beq	a5,s10,10bc <vprintf+0xf2>
      } else if(c == 'p') {
    1050:	09b78463          	beq	a5,s11,10d8 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    1054:	07300713          	li	a4,115
    1058:	0ce78663          	beq	a5,a4,1124 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    105c:	06300713          	li	a4,99
    1060:	0ee78e63          	beq	a5,a4,115c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    1064:	11478863          	beq	a5,s4,1174 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1068:	85d2                	mv	a1,s4
    106a:	8556                	mv	a0,s5
    106c:	00000097          	auipc	ra,0x0
    1070:	e92080e7          	jalr	-366(ra) # efe <putc>
        putc(fd, c);
    1074:	85ca                	mv	a1,s2
    1076:	8556                	mv	a0,s5
    1078:	00000097          	auipc	ra,0x0
    107c:	e86080e7          	jalr	-378(ra) # efe <putc>
      }
      state = 0;
    1080:	4981                	li	s3,0
    1082:	b765                	j	102a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    1084:	008b0913          	addi	s2,s6,8
    1088:	4685                	li	a3,1
    108a:	4629                	li	a2,10
    108c:	000b2583          	lw	a1,0(s6)
    1090:	8556                	mv	a0,s5
    1092:	00000097          	auipc	ra,0x0
    1096:	e8e080e7          	jalr	-370(ra) # f20 <printint>
    109a:	8b4a                	mv	s6,s2
      state = 0;
    109c:	4981                	li	s3,0
    109e:	b771                	j	102a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    10a0:	008b0913          	addi	s2,s6,8
    10a4:	4681                	li	a3,0
    10a6:	4629                	li	a2,10
    10a8:	000b2583          	lw	a1,0(s6)
    10ac:	8556                	mv	a0,s5
    10ae:	00000097          	auipc	ra,0x0
    10b2:	e72080e7          	jalr	-398(ra) # f20 <printint>
    10b6:	8b4a                	mv	s6,s2
      state = 0;
    10b8:	4981                	li	s3,0
    10ba:	bf85                	j	102a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    10bc:	008b0913          	addi	s2,s6,8
    10c0:	4681                	li	a3,0
    10c2:	4641                	li	a2,16
    10c4:	000b2583          	lw	a1,0(s6)
    10c8:	8556                	mv	a0,s5
    10ca:	00000097          	auipc	ra,0x0
    10ce:	e56080e7          	jalr	-426(ra) # f20 <printint>
    10d2:	8b4a                	mv	s6,s2
      state = 0;
    10d4:	4981                	li	s3,0
    10d6:	bf91                	j	102a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    10d8:	008b0793          	addi	a5,s6,8
    10dc:	f8f43423          	sd	a5,-120(s0)
    10e0:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    10e4:	03000593          	li	a1,48
    10e8:	8556                	mv	a0,s5
    10ea:	00000097          	auipc	ra,0x0
    10ee:	e14080e7          	jalr	-492(ra) # efe <putc>
  putc(fd, 'x');
    10f2:	85ea                	mv	a1,s10
    10f4:	8556                	mv	a0,s5
    10f6:	00000097          	auipc	ra,0x0
    10fa:	e08080e7          	jalr	-504(ra) # efe <putc>
    10fe:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1100:	03c9d793          	srli	a5,s3,0x3c
    1104:	97de                	add	a5,a5,s7
    1106:	0007c583          	lbu	a1,0(a5)
    110a:	8556                	mv	a0,s5
    110c:	00000097          	auipc	ra,0x0
    1110:	df2080e7          	jalr	-526(ra) # efe <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1114:	0992                	slli	s3,s3,0x4
    1116:	397d                	addiw	s2,s2,-1
    1118:	fe0914e3          	bnez	s2,1100 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    111c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    1120:	4981                	li	s3,0
    1122:	b721                	j	102a <vprintf+0x60>
        s = va_arg(ap, char*);
    1124:	008b0993          	addi	s3,s6,8
    1128:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    112c:	02090163          	beqz	s2,114e <vprintf+0x184>
        while(*s != 0){
    1130:	00094583          	lbu	a1,0(s2)
    1134:	c9a1                	beqz	a1,1184 <vprintf+0x1ba>
          putc(fd, *s);
    1136:	8556                	mv	a0,s5
    1138:	00000097          	auipc	ra,0x0
    113c:	dc6080e7          	jalr	-570(ra) # efe <putc>
          s++;
    1140:	0905                	addi	s2,s2,1
        while(*s != 0){
    1142:	00094583          	lbu	a1,0(s2)
    1146:	f9e5                	bnez	a1,1136 <vprintf+0x16c>
        s = va_arg(ap, char*);
    1148:	8b4e                	mv	s6,s3
      state = 0;
    114a:	4981                	li	s3,0
    114c:	bdf9                	j	102a <vprintf+0x60>
          s = "(null)";
    114e:	00000917          	auipc	s2,0x0
    1152:	51290913          	addi	s2,s2,1298 # 1660 <malloc+0x3cc>
        while(*s != 0){
    1156:	02800593          	li	a1,40
    115a:	bff1                	j	1136 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    115c:	008b0913          	addi	s2,s6,8
    1160:	000b4583          	lbu	a1,0(s6)
    1164:	8556                	mv	a0,s5
    1166:	00000097          	auipc	ra,0x0
    116a:	d98080e7          	jalr	-616(ra) # efe <putc>
    116e:	8b4a                	mv	s6,s2
      state = 0;
    1170:	4981                	li	s3,0
    1172:	bd65                	j	102a <vprintf+0x60>
        putc(fd, c);
    1174:	85d2                	mv	a1,s4
    1176:	8556                	mv	a0,s5
    1178:	00000097          	auipc	ra,0x0
    117c:	d86080e7          	jalr	-634(ra) # efe <putc>
      state = 0;
    1180:	4981                	li	s3,0
    1182:	b565                	j	102a <vprintf+0x60>
        s = va_arg(ap, char*);
    1184:	8b4e                	mv	s6,s3
      state = 0;
    1186:	4981                	li	s3,0
    1188:	b54d                	j	102a <vprintf+0x60>
    }
  }
}
    118a:	70e6                	ld	ra,120(sp)
    118c:	7446                	ld	s0,112(sp)
    118e:	74a6                	ld	s1,104(sp)
    1190:	7906                	ld	s2,96(sp)
    1192:	69e6                	ld	s3,88(sp)
    1194:	6a46                	ld	s4,80(sp)
    1196:	6aa6                	ld	s5,72(sp)
    1198:	6b06                	ld	s6,64(sp)
    119a:	7be2                	ld	s7,56(sp)
    119c:	7c42                	ld	s8,48(sp)
    119e:	7ca2                	ld	s9,40(sp)
    11a0:	7d02                	ld	s10,32(sp)
    11a2:	6de2                	ld	s11,24(sp)
    11a4:	6109                	addi	sp,sp,128
    11a6:	8082                	ret

00000000000011a8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    11a8:	715d                	addi	sp,sp,-80
    11aa:	ec06                	sd	ra,24(sp)
    11ac:	e822                	sd	s0,16(sp)
    11ae:	1000                	addi	s0,sp,32
    11b0:	e010                	sd	a2,0(s0)
    11b2:	e414                	sd	a3,8(s0)
    11b4:	e818                	sd	a4,16(s0)
    11b6:	ec1c                	sd	a5,24(s0)
    11b8:	03043023          	sd	a6,32(s0)
    11bc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    11c0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    11c4:	8622                	mv	a2,s0
    11c6:	00000097          	auipc	ra,0x0
    11ca:	e04080e7          	jalr	-508(ra) # fca <vprintf>
}
    11ce:	60e2                	ld	ra,24(sp)
    11d0:	6442                	ld	s0,16(sp)
    11d2:	6161                	addi	sp,sp,80
    11d4:	8082                	ret

00000000000011d6 <printf>:

void
printf(const char *fmt, ...)
{
    11d6:	711d                	addi	sp,sp,-96
    11d8:	ec06                	sd	ra,24(sp)
    11da:	e822                	sd	s0,16(sp)
    11dc:	1000                	addi	s0,sp,32
    11de:	e40c                	sd	a1,8(s0)
    11e0:	e810                	sd	a2,16(s0)
    11e2:	ec14                	sd	a3,24(s0)
    11e4:	f018                	sd	a4,32(s0)
    11e6:	f41c                	sd	a5,40(s0)
    11e8:	03043823          	sd	a6,48(s0)
    11ec:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    11f0:	00840613          	addi	a2,s0,8
    11f4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    11f8:	85aa                	mv	a1,a0
    11fa:	4505                	li	a0,1
    11fc:	00000097          	auipc	ra,0x0
    1200:	dce080e7          	jalr	-562(ra) # fca <vprintf>
}
    1204:	60e2                	ld	ra,24(sp)
    1206:	6442                	ld	s0,16(sp)
    1208:	6125                	addi	sp,sp,96
    120a:	8082                	ret

000000000000120c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    120c:	1141                	addi	sp,sp,-16
    120e:	e422                	sd	s0,8(sp)
    1210:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1212:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1216:	00000797          	auipc	a5,0x0
    121a:	4727b783          	ld	a5,1138(a5) # 1688 <freep>
    121e:	a805                	j	124e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1220:	4618                	lw	a4,8(a2)
    1222:	9db9                	addw	a1,a1,a4
    1224:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1228:	6398                	ld	a4,0(a5)
    122a:	6318                	ld	a4,0(a4)
    122c:	fee53823          	sd	a4,-16(a0)
    1230:	a091                	j	1274 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1232:	ff852703          	lw	a4,-8(a0)
    1236:	9e39                	addw	a2,a2,a4
    1238:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    123a:	ff053703          	ld	a4,-16(a0)
    123e:	e398                	sd	a4,0(a5)
    1240:	a099                	j	1286 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1242:	6398                	ld	a4,0(a5)
    1244:	00e7e463          	bltu	a5,a4,124c <free+0x40>
    1248:	00e6ea63          	bltu	a3,a4,125c <free+0x50>
{
    124c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    124e:	fed7fae3          	bgeu	a5,a3,1242 <free+0x36>
    1252:	6398                	ld	a4,0(a5)
    1254:	00e6e463          	bltu	a3,a4,125c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1258:	fee7eae3          	bltu	a5,a4,124c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    125c:	ff852583          	lw	a1,-8(a0)
    1260:	6390                	ld	a2,0(a5)
    1262:	02059713          	slli	a4,a1,0x20
    1266:	9301                	srli	a4,a4,0x20
    1268:	0712                	slli	a4,a4,0x4
    126a:	9736                	add	a4,a4,a3
    126c:	fae60ae3          	beq	a2,a4,1220 <free+0x14>
    bp->s.ptr = p->s.ptr;
    1270:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1274:	4790                	lw	a2,8(a5)
    1276:	02061713          	slli	a4,a2,0x20
    127a:	9301                	srli	a4,a4,0x20
    127c:	0712                	slli	a4,a4,0x4
    127e:	973e                	add	a4,a4,a5
    1280:	fae689e3          	beq	a3,a4,1232 <free+0x26>
  } else
    p->s.ptr = bp;
    1284:	e394                	sd	a3,0(a5)
  freep = p;
    1286:	00000717          	auipc	a4,0x0
    128a:	40f73123          	sd	a5,1026(a4) # 1688 <freep>
}
    128e:	6422                	ld	s0,8(sp)
    1290:	0141                	addi	sp,sp,16
    1292:	8082                	ret

0000000000001294 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1294:	7139                	addi	sp,sp,-64
    1296:	fc06                	sd	ra,56(sp)
    1298:	f822                	sd	s0,48(sp)
    129a:	f426                	sd	s1,40(sp)
    129c:	f04a                	sd	s2,32(sp)
    129e:	ec4e                	sd	s3,24(sp)
    12a0:	e852                	sd	s4,16(sp)
    12a2:	e456                	sd	s5,8(sp)
    12a4:	e05a                	sd	s6,0(sp)
    12a6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    12a8:	02051493          	slli	s1,a0,0x20
    12ac:	9081                	srli	s1,s1,0x20
    12ae:	04bd                	addi	s1,s1,15
    12b0:	8091                	srli	s1,s1,0x4
    12b2:	0014899b          	addiw	s3,s1,1
    12b6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    12b8:	00000517          	auipc	a0,0x0
    12bc:	3d053503          	ld	a0,976(a0) # 1688 <freep>
    12c0:	c515                	beqz	a0,12ec <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12c2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12c4:	4798                	lw	a4,8(a5)
    12c6:	02977f63          	bgeu	a4,s1,1304 <malloc+0x70>
    12ca:	8a4e                	mv	s4,s3
    12cc:	0009871b          	sext.w	a4,s3
    12d0:	6685                	lui	a3,0x1
    12d2:	00d77363          	bgeu	a4,a3,12d8 <malloc+0x44>
    12d6:	6a05                	lui	s4,0x1
    12d8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    12dc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    12e0:	00000917          	auipc	s2,0x0
    12e4:	3a890913          	addi	s2,s2,936 # 1688 <freep>
  if(p == (char*)-1)
    12e8:	5afd                	li	s5,-1
    12ea:	a88d                	j	135c <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    12ec:	00000797          	auipc	a5,0x0
    12f0:	78c78793          	addi	a5,a5,1932 # 1a78 <base>
    12f4:	00000717          	auipc	a4,0x0
    12f8:	38f73a23          	sd	a5,916(a4) # 1688 <freep>
    12fc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    12fe:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1302:	b7e1                	j	12ca <malloc+0x36>
      if(p->s.size == nunits)
    1304:	02e48b63          	beq	s1,a4,133a <malloc+0xa6>
        p->s.size -= nunits;
    1308:	4137073b          	subw	a4,a4,s3
    130c:	c798                	sw	a4,8(a5)
        p += p->s.size;
    130e:	1702                	slli	a4,a4,0x20
    1310:	9301                	srli	a4,a4,0x20
    1312:	0712                	slli	a4,a4,0x4
    1314:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1316:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    131a:	00000717          	auipc	a4,0x0
    131e:	36a73723          	sd	a0,878(a4) # 1688 <freep>
      return (void*)(p + 1);
    1322:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1326:	70e2                	ld	ra,56(sp)
    1328:	7442                	ld	s0,48(sp)
    132a:	74a2                	ld	s1,40(sp)
    132c:	7902                	ld	s2,32(sp)
    132e:	69e2                	ld	s3,24(sp)
    1330:	6a42                	ld	s4,16(sp)
    1332:	6aa2                	ld	s5,8(sp)
    1334:	6b02                	ld	s6,0(sp)
    1336:	6121                	addi	sp,sp,64
    1338:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    133a:	6398                	ld	a4,0(a5)
    133c:	e118                	sd	a4,0(a0)
    133e:	bff1                	j	131a <malloc+0x86>
  hp->s.size = nu;
    1340:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1344:	0541                	addi	a0,a0,16
    1346:	00000097          	auipc	ra,0x0
    134a:	ec6080e7          	jalr	-314(ra) # 120c <free>
  return freep;
    134e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1352:	d971                	beqz	a0,1326 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1354:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1356:	4798                	lw	a4,8(a5)
    1358:	fa9776e3          	bgeu	a4,s1,1304 <malloc+0x70>
    if(p == freep)
    135c:	00093703          	ld	a4,0(s2)
    1360:	853e                	mv	a0,a5
    1362:	fef719e3          	bne	a4,a5,1354 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    1366:	8552                	mv	a0,s4
    1368:	00000097          	auipc	ra,0x0
    136c:	b7e080e7          	jalr	-1154(ra) # ee6 <sbrk>
  if(p == (char*)-1)
    1370:	fd5518e3          	bne	a0,s5,1340 <malloc+0xac>
        return 0;
    1374:	4501                	li	a0,0
    1376:	bf45                	j	1326 <malloc+0x92>
