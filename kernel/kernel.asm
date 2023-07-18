
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	86013103          	ld	sp,-1952(sp) # 80008860 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	614050ef          	jal	ra,8000562a <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	addi	a5,a5,528 # 80026240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	fb6080e7          	jalr	-74(ra) # 80006010 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	056080e7          	jalr	86(ra) # 800060c4 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	a4a080e7          	jalr	-1462(ra) # 80005ad4 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	f4450513          	addi	a0,a0,-188 # 80009030 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	e8c080e7          	jalr	-372(ra) # 80005f80 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00026517          	auipc	a0,0x26
    80000104:	14050513          	addi	a0,a0,320 # 80026240 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	f0e48493          	addi	s1,s1,-242 # 80009030 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	ee4080e7          	jalr	-284(ra) # 80006010 <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	ef650513          	addi	a0,a0,-266 # 80009030 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	f80080e7          	jalr	-128(ra) # 800060c4 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	eca50513          	addi	a0,a0,-310 # 80009030 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	f56080e7          	jalr	-170(ra) # 800060c4 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ca19                	beqz	a2,80000194 <memset+0x1c>
    80000180:	87aa                	mv	a5,a0
    80000182:	1602                	slli	a2,a2,0x20
    80000184:	9201                	srli	a2,a2,0x20
    80000186:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000018e:	0785                	addi	a5,a5,1
    80000190:	fee79de3          	bne	a5,a4,8000018a <memset+0x12>
  }
  return dst;
}
    80000194:	6422                	ld	s0,8(sp)
    80000196:	0141                	addi	sp,sp,16
    80000198:	8082                	ret

000000008000019a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019a:	1141                	addi	sp,sp,-16
    8000019c:	e422                	sd	s0,8(sp)
    8000019e:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a0:	ca05                	beqz	a2,800001d0 <memcmp+0x36>
    800001a2:	fff6069b          	addiw	a3,a2,-1
    800001a6:	1682                	slli	a3,a3,0x20
    800001a8:	9281                	srli	a3,a3,0x20
    800001aa:	0685                	addi	a3,a3,1
    800001ac:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001ae:	00054783          	lbu	a5,0(a0)
    800001b2:	0005c703          	lbu	a4,0(a1)
    800001b6:	00e79863          	bne	a5,a4,800001c6 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001ba:	0505                	addi	a0,a0,1
    800001bc:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001be:	fed518e3          	bne	a0,a3,800001ae <memcmp+0x14>
  }

  return 0;
    800001c2:	4501                	li	a0,0
    800001c4:	a019                	j	800001ca <memcmp+0x30>
      return *s1 - *s2;
    800001c6:	40e7853b          	subw	a0,a5,a4
}
    800001ca:	6422                	ld	s0,8(sp)
    800001cc:	0141                	addi	sp,sp,16
    800001ce:	8082                	ret
  return 0;
    800001d0:	4501                	li	a0,0
    800001d2:	bfe5                	j	800001ca <memcmp+0x30>

00000000800001d4 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d4:	1141                	addi	sp,sp,-16
    800001d6:	e422                	sd	s0,8(sp)
    800001d8:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001da:	c205                	beqz	a2,800001fa <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001dc:	02a5e263          	bltu	a1,a0,80000200 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e0:	1602                	slli	a2,a2,0x20
    800001e2:	9201                	srli	a2,a2,0x20
    800001e4:	00c587b3          	add	a5,a1,a2
{
    800001e8:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ea:	0585                	addi	a1,a1,1
    800001ec:	0705                	addi	a4,a4,1
    800001ee:	fff5c683          	lbu	a3,-1(a1)
    800001f2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f6:	fef59ae3          	bne	a1,a5,800001ea <memmove+0x16>

  return dst;
}
    800001fa:	6422                	ld	s0,8(sp)
    800001fc:	0141                	addi	sp,sp,16
    800001fe:	8082                	ret
  if(s < d && s + n > d){
    80000200:	02061693          	slli	a3,a2,0x20
    80000204:	9281                	srli	a3,a3,0x20
    80000206:	00d58733          	add	a4,a1,a3
    8000020a:	fce57be3          	bgeu	a0,a4,800001e0 <memmove+0xc>
    d += n;
    8000020e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000210:	fff6079b          	addiw	a5,a2,-1
    80000214:	1782                	slli	a5,a5,0x20
    80000216:	9381                	srli	a5,a5,0x20
    80000218:	fff7c793          	not	a5,a5
    8000021c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000021e:	177d                	addi	a4,a4,-1
    80000220:	16fd                	addi	a3,a3,-1
    80000222:	00074603          	lbu	a2,0(a4)
    80000226:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022a:	fee79ae3          	bne	a5,a4,8000021e <memmove+0x4a>
    8000022e:	b7f1                	j	800001fa <memmove+0x26>

0000000080000230 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000230:	1141                	addi	sp,sp,-16
    80000232:	e406                	sd	ra,8(sp)
    80000234:	e022                	sd	s0,0(sp)
    80000236:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000238:	00000097          	auipc	ra,0x0
    8000023c:	f9c080e7          	jalr	-100(ra) # 800001d4 <memmove>
}
    80000240:	60a2                	ld	ra,8(sp)
    80000242:	6402                	ld	s0,0(sp)
    80000244:	0141                	addi	sp,sp,16
    80000246:	8082                	ret

0000000080000248 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000248:	1141                	addi	sp,sp,-16
    8000024a:	e422                	sd	s0,8(sp)
    8000024c:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000024e:	ce11                	beqz	a2,8000026a <strncmp+0x22>
    80000250:	00054783          	lbu	a5,0(a0)
    80000254:	cf89                	beqz	a5,8000026e <strncmp+0x26>
    80000256:	0005c703          	lbu	a4,0(a1)
    8000025a:	00f71a63          	bne	a4,a5,8000026e <strncmp+0x26>
    n--, p++, q++;
    8000025e:	367d                	addiw	a2,a2,-1
    80000260:	0505                	addi	a0,a0,1
    80000262:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000264:	f675                	bnez	a2,80000250 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000266:	4501                	li	a0,0
    80000268:	a809                	j	8000027a <strncmp+0x32>
    8000026a:	4501                	li	a0,0
    8000026c:	a039                	j	8000027a <strncmp+0x32>
  if(n == 0)
    8000026e:	ca09                	beqz	a2,80000280 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000270:	00054503          	lbu	a0,0(a0)
    80000274:	0005c783          	lbu	a5,0(a1)
    80000278:	9d1d                	subw	a0,a0,a5
}
    8000027a:	6422                	ld	s0,8(sp)
    8000027c:	0141                	addi	sp,sp,16
    8000027e:	8082                	ret
    return 0;
    80000280:	4501                	li	a0,0
    80000282:	bfe5                	j	8000027a <strncmp+0x32>

0000000080000284 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000284:	1141                	addi	sp,sp,-16
    80000286:	e422                	sd	s0,8(sp)
    80000288:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028a:	872a                	mv	a4,a0
    8000028c:	8832                	mv	a6,a2
    8000028e:	367d                	addiw	a2,a2,-1
    80000290:	01005963          	blez	a6,800002a2 <strncpy+0x1e>
    80000294:	0705                	addi	a4,a4,1
    80000296:	0005c783          	lbu	a5,0(a1)
    8000029a:	fef70fa3          	sb	a5,-1(a4)
    8000029e:	0585                	addi	a1,a1,1
    800002a0:	f7f5                	bnez	a5,8000028c <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a2:	86ba                	mv	a3,a4
    800002a4:	00c05c63          	blez	a2,800002bc <strncpy+0x38>
    *s++ = 0;
    800002a8:	0685                	addi	a3,a3,1
    800002aa:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002ae:	fff6c793          	not	a5,a3
    800002b2:	9fb9                	addw	a5,a5,a4
    800002b4:	010787bb          	addw	a5,a5,a6
    800002b8:	fef048e3          	bgtz	a5,800002a8 <strncpy+0x24>
  return os;
}
    800002bc:	6422                	ld	s0,8(sp)
    800002be:	0141                	addi	sp,sp,16
    800002c0:	8082                	ret

00000000800002c2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c2:	1141                	addi	sp,sp,-16
    800002c4:	e422                	sd	s0,8(sp)
    800002c6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002c8:	02c05363          	blez	a2,800002ee <safestrcpy+0x2c>
    800002cc:	fff6069b          	addiw	a3,a2,-1
    800002d0:	1682                	slli	a3,a3,0x20
    800002d2:	9281                	srli	a3,a3,0x20
    800002d4:	96ae                	add	a3,a3,a1
    800002d6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002d8:	00d58963          	beq	a1,a3,800002ea <safestrcpy+0x28>
    800002dc:	0585                	addi	a1,a1,1
    800002de:	0785                	addi	a5,a5,1
    800002e0:	fff5c703          	lbu	a4,-1(a1)
    800002e4:	fee78fa3          	sb	a4,-1(a5)
    800002e8:	fb65                	bnez	a4,800002d8 <safestrcpy+0x16>
    ;
  *s = 0;
    800002ea:	00078023          	sb	zero,0(a5)
  return os;
}
    800002ee:	6422                	ld	s0,8(sp)
    800002f0:	0141                	addi	sp,sp,16
    800002f2:	8082                	ret

00000000800002f4 <strlen>:

int
strlen(const char *s)
{
    800002f4:	1141                	addi	sp,sp,-16
    800002f6:	e422                	sd	s0,8(sp)
    800002f8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fa:	00054783          	lbu	a5,0(a0)
    800002fe:	cf91                	beqz	a5,8000031a <strlen+0x26>
    80000300:	0505                	addi	a0,a0,1
    80000302:	87aa                	mv	a5,a0
    80000304:	4685                	li	a3,1
    80000306:	9e89                	subw	a3,a3,a0
    80000308:	00f6853b          	addw	a0,a3,a5
    8000030c:	0785                	addi	a5,a5,1
    8000030e:	fff7c703          	lbu	a4,-1(a5)
    80000312:	fb7d                	bnez	a4,80000308 <strlen+0x14>
    ;
  return n;
}
    80000314:	6422                	ld	s0,8(sp)
    80000316:	0141                	addi	sp,sp,16
    80000318:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031a:	4501                	li	a0,0
    8000031c:	bfe5                	j	80000314 <strlen+0x20>

000000008000031e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000031e:	1141                	addi	sp,sp,-16
    80000320:	e406                	sd	ra,8(sp)
    80000322:	e022                	sd	s0,0(sp)
    80000324:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000326:	00001097          	auipc	ra,0x1
    8000032a:	af0080e7          	jalr	-1296(ra) # 80000e16 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000032e:	00009717          	auipc	a4,0x9
    80000332:	cd270713          	addi	a4,a4,-814 # 80009000 <started>
  if(cpuid() == 0){
    80000336:	c139                	beqz	a0,8000037c <main+0x5e>
    while(started == 0)
    80000338:	431c                	lw	a5,0(a4)
    8000033a:	2781                	sext.w	a5,a5
    8000033c:	dff5                	beqz	a5,80000338 <main+0x1a>
      ;
    __sync_synchronize();
    8000033e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000342:	00001097          	auipc	ra,0x1
    80000346:	ad4080e7          	jalr	-1324(ra) # 80000e16 <cpuid>
    8000034a:	85aa                	mv	a1,a0
    8000034c:	00008517          	auipc	a0,0x8
    80000350:	cec50513          	addi	a0,a0,-788 # 80008038 <etext+0x38>
    80000354:	00005097          	auipc	ra,0x5
    80000358:	7ca080e7          	jalr	1994(ra) # 80005b1e <printf>
    kvminithart();    // turn on paging
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	0d8080e7          	jalr	216(ra) # 80000434 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000364:	00001097          	auipc	ra,0x1
    80000368:	72e080e7          	jalr	1838(ra) # 80001a92 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036c:	00005097          	auipc	ra,0x5
    80000370:	c94080e7          	jalr	-876(ra) # 80005000 <plicinithart>
  }

  scheduler();        
    80000374:	00001097          	auipc	ra,0x1
    80000378:	fdc080e7          	jalr	-36(ra) # 80001350 <scheduler>
    consoleinit();
    8000037c:	00005097          	auipc	ra,0x5
    80000380:	66a080e7          	jalr	1642(ra) # 800059e6 <consoleinit>
    printfinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	97a080e7          	jalr	-1670(ra) # 80005cfe <printfinit>
    printf("\n");
    8000038c:	00008517          	auipc	a0,0x8
    80000390:	cbc50513          	addi	a0,a0,-836 # 80008048 <etext+0x48>
    80000394:	00005097          	auipc	ra,0x5
    80000398:	78a080e7          	jalr	1930(ra) # 80005b1e <printf>
    printf("xv6 kernel is booting\n");
    8000039c:	00008517          	auipc	a0,0x8
    800003a0:	c8450513          	addi	a0,a0,-892 # 80008020 <etext+0x20>
    800003a4:	00005097          	auipc	ra,0x5
    800003a8:	77a080e7          	jalr	1914(ra) # 80005b1e <printf>
    printf("\n");
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c9c50513          	addi	a0,a0,-868 # 80008048 <etext+0x48>
    800003b4:	00005097          	auipc	ra,0x5
    800003b8:	76a080e7          	jalr	1898(ra) # 80005b1e <printf>
    kinit();         // physical page allocator
    800003bc:	00000097          	auipc	ra,0x0
    800003c0:	d20080e7          	jalr	-736(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	322080e7          	jalr	802(ra) # 800006e6 <kvminit>
    kvminithart();   // turn on paging
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	068080e7          	jalr	104(ra) # 80000434 <kvminithart>
    procinit();      // process table
    800003d4:	00001097          	auipc	ra,0x1
    800003d8:	992080e7          	jalr	-1646(ra) # 80000d66 <procinit>
    trapinit();      // trap vectors
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	68e080e7          	jalr	1678(ra) # 80001a6a <trapinit>
    trapinithart();  // install kernel trap vector
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	6ae080e7          	jalr	1710(ra) # 80001a92 <trapinithart>
    plicinit();      // set up interrupt controller
    800003ec:	00005097          	auipc	ra,0x5
    800003f0:	bfe080e7          	jalr	-1026(ra) # 80004fea <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	c0c080e7          	jalr	-1012(ra) # 80005000 <plicinithart>
    binit();         // buffer cache
    800003fc:	00002097          	auipc	ra,0x2
    80000400:	dd6080e7          	jalr	-554(ra) # 800021d2 <binit>
    iinit();         // inode table
    80000404:	00002097          	auipc	ra,0x2
    80000408:	466080e7          	jalr	1126(ra) # 8000286a <iinit>
    fileinit();      // file table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	410080e7          	jalr	1040(ra) # 8000381c <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000414:	00005097          	auipc	ra,0x5
    80000418:	d0e080e7          	jalr	-754(ra) # 80005122 <virtio_disk_init>
    userinit();      // first user process
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	cfe080e7          	jalr	-770(ra) # 8000111a <userinit>
    __sync_synchronize();
    80000424:	0ff0000f          	fence
    started = 1;
    80000428:	4785                	li	a5,1
    8000042a:	00009717          	auipc	a4,0x9
    8000042e:	bcf72b23          	sw	a5,-1066(a4) # 80009000 <started>
    80000432:	b789                	j	80000374 <main+0x56>

0000000080000434 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000434:	1141                	addi	sp,sp,-16
    80000436:	e422                	sd	s0,8(sp)
    80000438:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000043a:	00009797          	auipc	a5,0x9
    8000043e:	bce7b783          	ld	a5,-1074(a5) # 80009008 <kernel_pagetable>
    80000442:	83b1                	srli	a5,a5,0xc
    80000444:	577d                	li	a4,-1
    80000446:	177e                	slli	a4,a4,0x3f
    80000448:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000044a:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000044e:	12000073          	sfence.vma
  sfence_vma();
}
    80000452:	6422                	ld	s0,8(sp)
    80000454:	0141                	addi	sp,sp,16
    80000456:	8082                	ret

0000000080000458 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000458:	7139                	addi	sp,sp,-64
    8000045a:	fc06                	sd	ra,56(sp)
    8000045c:	f822                	sd	s0,48(sp)
    8000045e:	f426                	sd	s1,40(sp)
    80000460:	f04a                	sd	s2,32(sp)
    80000462:	ec4e                	sd	s3,24(sp)
    80000464:	e852                	sd	s4,16(sp)
    80000466:	e456                	sd	s5,8(sp)
    80000468:	e05a                	sd	s6,0(sp)
    8000046a:	0080                	addi	s0,sp,64
    8000046c:	84aa                	mv	s1,a0
    8000046e:	89ae                	mv	s3,a1
    80000470:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000472:	57fd                	li	a5,-1
    80000474:	83e9                	srli	a5,a5,0x1a
    80000476:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000478:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000047a:	04b7f263          	bgeu	a5,a1,800004be <walk+0x66>
    panic("walk");
    8000047e:	00008517          	auipc	a0,0x8
    80000482:	bd250513          	addi	a0,a0,-1070 # 80008050 <etext+0x50>
    80000486:	00005097          	auipc	ra,0x5
    8000048a:	64e080e7          	jalr	1614(ra) # 80005ad4 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000048e:	060a8663          	beqz	s5,800004fa <walk+0xa2>
    80000492:	00000097          	auipc	ra,0x0
    80000496:	c86080e7          	jalr	-890(ra) # 80000118 <kalloc>
    8000049a:	84aa                	mv	s1,a0
    8000049c:	c529                	beqz	a0,800004e6 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000049e:	6605                	lui	a2,0x1
    800004a0:	4581                	li	a1,0
    800004a2:	00000097          	auipc	ra,0x0
    800004a6:	cd6080e7          	jalr	-810(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004aa:	00c4d793          	srli	a5,s1,0xc
    800004ae:	07aa                	slli	a5,a5,0xa
    800004b0:	0017e793          	ori	a5,a5,1
    800004b4:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004b8:	3a5d                	addiw	s4,s4,-9
    800004ba:	036a0063          	beq	s4,s6,800004da <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004be:	0149d933          	srl	s2,s3,s4
    800004c2:	1ff97913          	andi	s2,s2,511
    800004c6:	090e                	slli	s2,s2,0x3
    800004c8:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004ca:	00093483          	ld	s1,0(s2)
    800004ce:	0014f793          	andi	a5,s1,1
    800004d2:	dfd5                	beqz	a5,8000048e <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d4:	80a9                	srli	s1,s1,0xa
    800004d6:	04b2                	slli	s1,s1,0xc
    800004d8:	b7c5                	j	800004b8 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004da:	00c9d513          	srli	a0,s3,0xc
    800004de:	1ff57513          	andi	a0,a0,511
    800004e2:	050e                	slli	a0,a0,0x3
    800004e4:	9526                	add	a0,a0,s1
}
    800004e6:	70e2                	ld	ra,56(sp)
    800004e8:	7442                	ld	s0,48(sp)
    800004ea:	74a2                	ld	s1,40(sp)
    800004ec:	7902                	ld	s2,32(sp)
    800004ee:	69e2                	ld	s3,24(sp)
    800004f0:	6a42                	ld	s4,16(sp)
    800004f2:	6aa2                	ld	s5,8(sp)
    800004f4:	6b02                	ld	s6,0(sp)
    800004f6:	6121                	addi	sp,sp,64
    800004f8:	8082                	ret
        return 0;
    800004fa:	4501                	li	a0,0
    800004fc:	b7ed                	j	800004e6 <walk+0x8e>

00000000800004fe <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800004fe:	57fd                	li	a5,-1
    80000500:	83e9                	srli	a5,a5,0x1a
    80000502:	00b7f463          	bgeu	a5,a1,8000050a <walkaddr+0xc>
    return 0;
    80000506:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000508:	8082                	ret
{
    8000050a:	1141                	addi	sp,sp,-16
    8000050c:	e406                	sd	ra,8(sp)
    8000050e:	e022                	sd	s0,0(sp)
    80000510:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000512:	4601                	li	a2,0
    80000514:	00000097          	auipc	ra,0x0
    80000518:	f44080e7          	jalr	-188(ra) # 80000458 <walk>
  if(pte == 0)
    8000051c:	c105                	beqz	a0,8000053c <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000051e:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000520:	0117f693          	andi	a3,a5,17
    80000524:	4745                	li	a4,17
    return 0;
    80000526:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000528:	00e68663          	beq	a3,a4,80000534 <walkaddr+0x36>
}
    8000052c:	60a2                	ld	ra,8(sp)
    8000052e:	6402                	ld	s0,0(sp)
    80000530:	0141                	addi	sp,sp,16
    80000532:	8082                	ret
  pa = PTE2PA(*pte);
    80000534:	00a7d513          	srli	a0,a5,0xa
    80000538:	0532                	slli	a0,a0,0xc
  return pa;
    8000053a:	bfcd                	j	8000052c <walkaddr+0x2e>
    return 0;
    8000053c:	4501                	li	a0,0
    8000053e:	b7fd                	j	8000052c <walkaddr+0x2e>

0000000080000540 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000540:	715d                	addi	sp,sp,-80
    80000542:	e486                	sd	ra,72(sp)
    80000544:	e0a2                	sd	s0,64(sp)
    80000546:	fc26                	sd	s1,56(sp)
    80000548:	f84a                	sd	s2,48(sp)
    8000054a:	f44e                	sd	s3,40(sp)
    8000054c:	f052                	sd	s4,32(sp)
    8000054e:	ec56                	sd	s5,24(sp)
    80000550:	e85a                	sd	s6,16(sp)
    80000552:	e45e                	sd	s7,8(sp)
    80000554:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000556:	c639                	beqz	a2,800005a4 <mappages+0x64>
    80000558:	8aaa                	mv	s5,a0
    8000055a:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000055c:	77fd                	lui	a5,0xfffff
    8000055e:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80000562:	15fd                	addi	a1,a1,-1
    80000564:	00c589b3          	add	s3,a1,a2
    80000568:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    8000056c:	8952                	mv	s2,s4
    8000056e:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000572:	6b85                	lui	s7,0x1
    80000574:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000578:	4605                	li	a2,1
    8000057a:	85ca                	mv	a1,s2
    8000057c:	8556                	mv	a0,s5
    8000057e:	00000097          	auipc	ra,0x0
    80000582:	eda080e7          	jalr	-294(ra) # 80000458 <walk>
    80000586:	cd1d                	beqz	a0,800005c4 <mappages+0x84>
    if(*pte & PTE_V)
    80000588:	611c                	ld	a5,0(a0)
    8000058a:	8b85                	andi	a5,a5,1
    8000058c:	e785                	bnez	a5,800005b4 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000058e:	80b1                	srli	s1,s1,0xc
    80000590:	04aa                	slli	s1,s1,0xa
    80000592:	0164e4b3          	or	s1,s1,s6
    80000596:	0014e493          	ori	s1,s1,1
    8000059a:	e104                	sd	s1,0(a0)
    if(a == last)
    8000059c:	05390063          	beq	s2,s3,800005dc <mappages+0x9c>
    a += PGSIZE;
    800005a0:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a2:	bfc9                	j	80000574 <mappages+0x34>
    panic("mappages: size");
    800005a4:	00008517          	auipc	a0,0x8
    800005a8:	ab450513          	addi	a0,a0,-1356 # 80008058 <etext+0x58>
    800005ac:	00005097          	auipc	ra,0x5
    800005b0:	528080e7          	jalr	1320(ra) # 80005ad4 <panic>
      panic("mappages: remap");
    800005b4:	00008517          	auipc	a0,0x8
    800005b8:	ab450513          	addi	a0,a0,-1356 # 80008068 <etext+0x68>
    800005bc:	00005097          	auipc	ra,0x5
    800005c0:	518080e7          	jalr	1304(ra) # 80005ad4 <panic>
      return -1;
    800005c4:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005c6:	60a6                	ld	ra,72(sp)
    800005c8:	6406                	ld	s0,64(sp)
    800005ca:	74e2                	ld	s1,56(sp)
    800005cc:	7942                	ld	s2,48(sp)
    800005ce:	79a2                	ld	s3,40(sp)
    800005d0:	7a02                	ld	s4,32(sp)
    800005d2:	6ae2                	ld	s5,24(sp)
    800005d4:	6b42                	ld	s6,16(sp)
    800005d6:	6ba2                	ld	s7,8(sp)
    800005d8:	6161                	addi	sp,sp,80
    800005da:	8082                	ret
  return 0;
    800005dc:	4501                	li	a0,0
    800005de:	b7e5                	j	800005c6 <mappages+0x86>

00000000800005e0 <kvmmap>:
{
    800005e0:	1141                	addi	sp,sp,-16
    800005e2:	e406                	sd	ra,8(sp)
    800005e4:	e022                	sd	s0,0(sp)
    800005e6:	0800                	addi	s0,sp,16
    800005e8:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005ea:	86b2                	mv	a3,a2
    800005ec:	863e                	mv	a2,a5
    800005ee:	00000097          	auipc	ra,0x0
    800005f2:	f52080e7          	jalr	-174(ra) # 80000540 <mappages>
    800005f6:	e509                	bnez	a0,80000600 <kvmmap+0x20>
}
    800005f8:	60a2                	ld	ra,8(sp)
    800005fa:	6402                	ld	s0,0(sp)
    800005fc:	0141                	addi	sp,sp,16
    800005fe:	8082                	ret
    panic("kvmmap");
    80000600:	00008517          	auipc	a0,0x8
    80000604:	a7850513          	addi	a0,a0,-1416 # 80008078 <etext+0x78>
    80000608:	00005097          	auipc	ra,0x5
    8000060c:	4cc080e7          	jalr	1228(ra) # 80005ad4 <panic>

0000000080000610 <kvmmake>:
{
    80000610:	1101                	addi	sp,sp,-32
    80000612:	ec06                	sd	ra,24(sp)
    80000614:	e822                	sd	s0,16(sp)
    80000616:	e426                	sd	s1,8(sp)
    80000618:	e04a                	sd	s2,0(sp)
    8000061a:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000061c:	00000097          	auipc	ra,0x0
    80000620:	afc080e7          	jalr	-1284(ra) # 80000118 <kalloc>
    80000624:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000626:	6605                	lui	a2,0x1
    80000628:	4581                	li	a1,0
    8000062a:	00000097          	auipc	ra,0x0
    8000062e:	b4e080e7          	jalr	-1202(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000632:	4719                	li	a4,6
    80000634:	6685                	lui	a3,0x1
    80000636:	10000637          	lui	a2,0x10000
    8000063a:	100005b7          	lui	a1,0x10000
    8000063e:	8526                	mv	a0,s1
    80000640:	00000097          	auipc	ra,0x0
    80000644:	fa0080e7          	jalr	-96(ra) # 800005e0 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000648:	4719                	li	a4,6
    8000064a:	6685                	lui	a3,0x1
    8000064c:	10001637          	lui	a2,0x10001
    80000650:	100015b7          	lui	a1,0x10001
    80000654:	8526                	mv	a0,s1
    80000656:	00000097          	auipc	ra,0x0
    8000065a:	f8a080e7          	jalr	-118(ra) # 800005e0 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000065e:	4719                	li	a4,6
    80000660:	004006b7          	lui	a3,0x400
    80000664:	0c000637          	lui	a2,0xc000
    80000668:	0c0005b7          	lui	a1,0xc000
    8000066c:	8526                	mv	a0,s1
    8000066e:	00000097          	auipc	ra,0x0
    80000672:	f72080e7          	jalr	-142(ra) # 800005e0 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000676:	00008917          	auipc	s2,0x8
    8000067a:	98a90913          	addi	s2,s2,-1654 # 80008000 <etext>
    8000067e:	4729                	li	a4,10
    80000680:	80008697          	auipc	a3,0x80008
    80000684:	98068693          	addi	a3,a3,-1664 # 8000 <_entry-0x7fff8000>
    80000688:	4605                	li	a2,1
    8000068a:	067e                	slli	a2,a2,0x1f
    8000068c:	85b2                	mv	a1,a2
    8000068e:	8526                	mv	a0,s1
    80000690:	00000097          	auipc	ra,0x0
    80000694:	f50080e7          	jalr	-176(ra) # 800005e0 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000698:	4719                	li	a4,6
    8000069a:	46c5                	li	a3,17
    8000069c:	06ee                	slli	a3,a3,0x1b
    8000069e:	412686b3          	sub	a3,a3,s2
    800006a2:	864a                	mv	a2,s2
    800006a4:	85ca                	mv	a1,s2
    800006a6:	8526                	mv	a0,s1
    800006a8:	00000097          	auipc	ra,0x0
    800006ac:	f38080e7          	jalr	-200(ra) # 800005e0 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b0:	4729                	li	a4,10
    800006b2:	6685                	lui	a3,0x1
    800006b4:	00007617          	auipc	a2,0x7
    800006b8:	94c60613          	addi	a2,a2,-1716 # 80007000 <_trampoline>
    800006bc:	040005b7          	lui	a1,0x4000
    800006c0:	15fd                	addi	a1,a1,-1
    800006c2:	05b2                	slli	a1,a1,0xc
    800006c4:	8526                	mv	a0,s1
    800006c6:	00000097          	auipc	ra,0x0
    800006ca:	f1a080e7          	jalr	-230(ra) # 800005e0 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006ce:	8526                	mv	a0,s1
    800006d0:	00000097          	auipc	ra,0x0
    800006d4:	600080e7          	jalr	1536(ra) # 80000cd0 <proc_mapstacks>
}
    800006d8:	8526                	mv	a0,s1
    800006da:	60e2                	ld	ra,24(sp)
    800006dc:	6442                	ld	s0,16(sp)
    800006de:	64a2                	ld	s1,8(sp)
    800006e0:	6902                	ld	s2,0(sp)
    800006e2:	6105                	addi	sp,sp,32
    800006e4:	8082                	ret

00000000800006e6 <kvminit>:
{
    800006e6:	1141                	addi	sp,sp,-16
    800006e8:	e406                	sd	ra,8(sp)
    800006ea:	e022                	sd	s0,0(sp)
    800006ec:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006ee:	00000097          	auipc	ra,0x0
    800006f2:	f22080e7          	jalr	-222(ra) # 80000610 <kvmmake>
    800006f6:	00009797          	auipc	a5,0x9
    800006fa:	90a7b923          	sd	a0,-1774(a5) # 80009008 <kernel_pagetable>
}
    800006fe:	60a2                	ld	ra,8(sp)
    80000700:	6402                	ld	s0,0(sp)
    80000702:	0141                	addi	sp,sp,16
    80000704:	8082                	ret

0000000080000706 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000706:	715d                	addi	sp,sp,-80
    80000708:	e486                	sd	ra,72(sp)
    8000070a:	e0a2                	sd	s0,64(sp)
    8000070c:	fc26                	sd	s1,56(sp)
    8000070e:	f84a                	sd	s2,48(sp)
    80000710:	f44e                	sd	s3,40(sp)
    80000712:	f052                	sd	s4,32(sp)
    80000714:	ec56                	sd	s5,24(sp)
    80000716:	e85a                	sd	s6,16(sp)
    80000718:	e45e                	sd	s7,8(sp)
    8000071a:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000071c:	03459793          	slli	a5,a1,0x34
    80000720:	e795                	bnez	a5,8000074c <uvmunmap+0x46>
    80000722:	8a2a                	mv	s4,a0
    80000724:	892e                	mv	s2,a1
    80000726:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000728:	0632                	slli	a2,a2,0xc
    8000072a:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000072e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000730:	6b05                	lui	s6,0x1
    80000732:	0735e263          	bltu	a1,s3,80000796 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000736:	60a6                	ld	ra,72(sp)
    80000738:	6406                	ld	s0,64(sp)
    8000073a:	74e2                	ld	s1,56(sp)
    8000073c:	7942                	ld	s2,48(sp)
    8000073e:	79a2                	ld	s3,40(sp)
    80000740:	7a02                	ld	s4,32(sp)
    80000742:	6ae2                	ld	s5,24(sp)
    80000744:	6b42                	ld	s6,16(sp)
    80000746:	6ba2                	ld	s7,8(sp)
    80000748:	6161                	addi	sp,sp,80
    8000074a:	8082                	ret
    panic("uvmunmap: not aligned");
    8000074c:	00008517          	auipc	a0,0x8
    80000750:	93450513          	addi	a0,a0,-1740 # 80008080 <etext+0x80>
    80000754:	00005097          	auipc	ra,0x5
    80000758:	380080e7          	jalr	896(ra) # 80005ad4 <panic>
      panic("uvmunmap: walk");
    8000075c:	00008517          	auipc	a0,0x8
    80000760:	93c50513          	addi	a0,a0,-1732 # 80008098 <etext+0x98>
    80000764:	00005097          	auipc	ra,0x5
    80000768:	370080e7          	jalr	880(ra) # 80005ad4 <panic>
      panic("uvmunmap: not mapped");
    8000076c:	00008517          	auipc	a0,0x8
    80000770:	93c50513          	addi	a0,a0,-1732 # 800080a8 <etext+0xa8>
    80000774:	00005097          	auipc	ra,0x5
    80000778:	360080e7          	jalr	864(ra) # 80005ad4 <panic>
      panic("uvmunmap: not a leaf");
    8000077c:	00008517          	auipc	a0,0x8
    80000780:	94450513          	addi	a0,a0,-1724 # 800080c0 <etext+0xc0>
    80000784:	00005097          	auipc	ra,0x5
    80000788:	350080e7          	jalr	848(ra) # 80005ad4 <panic>
    *pte = 0;
    8000078c:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000790:	995a                	add	s2,s2,s6
    80000792:	fb3972e3          	bgeu	s2,s3,80000736 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80000796:	4601                	li	a2,0
    80000798:	85ca                	mv	a1,s2
    8000079a:	8552                	mv	a0,s4
    8000079c:	00000097          	auipc	ra,0x0
    800007a0:	cbc080e7          	jalr	-836(ra) # 80000458 <walk>
    800007a4:	84aa                	mv	s1,a0
    800007a6:	d95d                	beqz	a0,8000075c <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007a8:	6108                	ld	a0,0(a0)
    800007aa:	00157793          	andi	a5,a0,1
    800007ae:	dfdd                	beqz	a5,8000076c <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007b0:	3ff57793          	andi	a5,a0,1023
    800007b4:	fd7784e3          	beq	a5,s7,8000077c <uvmunmap+0x76>
    if(do_free){
    800007b8:	fc0a8ae3          	beqz	s5,8000078c <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007bc:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007be:	0532                	slli	a0,a0,0xc
    800007c0:	00000097          	auipc	ra,0x0
    800007c4:	85c080e7          	jalr	-1956(ra) # 8000001c <kfree>
    800007c8:	b7d1                	j	8000078c <uvmunmap+0x86>

00000000800007ca <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007ca:	1101                	addi	sp,sp,-32
    800007cc:	ec06                	sd	ra,24(sp)
    800007ce:	e822                	sd	s0,16(sp)
    800007d0:	e426                	sd	s1,8(sp)
    800007d2:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007d4:	00000097          	auipc	ra,0x0
    800007d8:	944080e7          	jalr	-1724(ra) # 80000118 <kalloc>
    800007dc:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007de:	c519                	beqz	a0,800007ec <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e0:	6605                	lui	a2,0x1
    800007e2:	4581                	li	a1,0
    800007e4:	00000097          	auipc	ra,0x0
    800007e8:	994080e7          	jalr	-1644(ra) # 80000178 <memset>
  return pagetable;
}
    800007ec:	8526                	mv	a0,s1
    800007ee:	60e2                	ld	ra,24(sp)
    800007f0:	6442                	ld	s0,16(sp)
    800007f2:	64a2                	ld	s1,8(sp)
    800007f4:	6105                	addi	sp,sp,32
    800007f6:	8082                	ret

00000000800007f8 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800007f8:	7179                	addi	sp,sp,-48
    800007fa:	f406                	sd	ra,40(sp)
    800007fc:	f022                	sd	s0,32(sp)
    800007fe:	ec26                	sd	s1,24(sp)
    80000800:	e84a                	sd	s2,16(sp)
    80000802:	e44e                	sd	s3,8(sp)
    80000804:	e052                	sd	s4,0(sp)
    80000806:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000808:	6785                	lui	a5,0x1
    8000080a:	04f67863          	bgeu	a2,a5,8000085a <uvminit+0x62>
    8000080e:	8a2a                	mv	s4,a0
    80000810:	89ae                	mv	s3,a1
    80000812:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000814:	00000097          	auipc	ra,0x0
    80000818:	904080e7          	jalr	-1788(ra) # 80000118 <kalloc>
    8000081c:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000081e:	6605                	lui	a2,0x1
    80000820:	4581                	li	a1,0
    80000822:	00000097          	auipc	ra,0x0
    80000826:	956080e7          	jalr	-1706(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000082a:	4779                	li	a4,30
    8000082c:	86ca                	mv	a3,s2
    8000082e:	6605                	lui	a2,0x1
    80000830:	4581                	li	a1,0
    80000832:	8552                	mv	a0,s4
    80000834:	00000097          	auipc	ra,0x0
    80000838:	d0c080e7          	jalr	-756(ra) # 80000540 <mappages>
  memmove(mem, src, sz);
    8000083c:	8626                	mv	a2,s1
    8000083e:	85ce                	mv	a1,s3
    80000840:	854a                	mv	a0,s2
    80000842:	00000097          	auipc	ra,0x0
    80000846:	992080e7          	jalr	-1646(ra) # 800001d4 <memmove>
}
    8000084a:	70a2                	ld	ra,40(sp)
    8000084c:	7402                	ld	s0,32(sp)
    8000084e:	64e2                	ld	s1,24(sp)
    80000850:	6942                	ld	s2,16(sp)
    80000852:	69a2                	ld	s3,8(sp)
    80000854:	6a02                	ld	s4,0(sp)
    80000856:	6145                	addi	sp,sp,48
    80000858:	8082                	ret
    panic("inituvm: more than a page");
    8000085a:	00008517          	auipc	a0,0x8
    8000085e:	87e50513          	addi	a0,a0,-1922 # 800080d8 <etext+0xd8>
    80000862:	00005097          	auipc	ra,0x5
    80000866:	272080e7          	jalr	626(ra) # 80005ad4 <panic>

000000008000086a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000086a:	1101                	addi	sp,sp,-32
    8000086c:	ec06                	sd	ra,24(sp)
    8000086e:	e822                	sd	s0,16(sp)
    80000870:	e426                	sd	s1,8(sp)
    80000872:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000874:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000876:	00b67d63          	bgeu	a2,a1,80000890 <uvmdealloc+0x26>
    8000087a:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000087c:	6785                	lui	a5,0x1
    8000087e:	17fd                	addi	a5,a5,-1
    80000880:	00f60733          	add	a4,a2,a5
    80000884:	767d                	lui	a2,0xfffff
    80000886:	8f71                	and	a4,a4,a2
    80000888:	97ae                	add	a5,a5,a1
    8000088a:	8ff1                	and	a5,a5,a2
    8000088c:	00f76863          	bltu	a4,a5,8000089c <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000890:	8526                	mv	a0,s1
    80000892:	60e2                	ld	ra,24(sp)
    80000894:	6442                	ld	s0,16(sp)
    80000896:	64a2                	ld	s1,8(sp)
    80000898:	6105                	addi	sp,sp,32
    8000089a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000089c:	8f99                	sub	a5,a5,a4
    8000089e:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a0:	4685                	li	a3,1
    800008a2:	0007861b          	sext.w	a2,a5
    800008a6:	85ba                	mv	a1,a4
    800008a8:	00000097          	auipc	ra,0x0
    800008ac:	e5e080e7          	jalr	-418(ra) # 80000706 <uvmunmap>
    800008b0:	b7c5                	j	80000890 <uvmdealloc+0x26>

00000000800008b2 <uvmalloc>:
  if(newsz < oldsz)
    800008b2:	0ab66163          	bltu	a2,a1,80000954 <uvmalloc+0xa2>
{
    800008b6:	7139                	addi	sp,sp,-64
    800008b8:	fc06                	sd	ra,56(sp)
    800008ba:	f822                	sd	s0,48(sp)
    800008bc:	f426                	sd	s1,40(sp)
    800008be:	f04a                	sd	s2,32(sp)
    800008c0:	ec4e                	sd	s3,24(sp)
    800008c2:	e852                	sd	s4,16(sp)
    800008c4:	e456                	sd	s5,8(sp)
    800008c6:	0080                	addi	s0,sp,64
    800008c8:	8aaa                	mv	s5,a0
    800008ca:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008cc:	6985                	lui	s3,0x1
    800008ce:	19fd                	addi	s3,s3,-1
    800008d0:	95ce                	add	a1,a1,s3
    800008d2:	79fd                	lui	s3,0xfffff
    800008d4:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008d8:	08c9f063          	bgeu	s3,a2,80000958 <uvmalloc+0xa6>
    800008dc:	894e                	mv	s2,s3
    mem = kalloc();
    800008de:	00000097          	auipc	ra,0x0
    800008e2:	83a080e7          	jalr	-1990(ra) # 80000118 <kalloc>
    800008e6:	84aa                	mv	s1,a0
    if(mem == 0){
    800008e8:	c51d                	beqz	a0,80000916 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008ea:	6605                	lui	a2,0x1
    800008ec:	4581                	li	a1,0
    800008ee:	00000097          	auipc	ra,0x0
    800008f2:	88a080e7          	jalr	-1910(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008f6:	4779                	li	a4,30
    800008f8:	86a6                	mv	a3,s1
    800008fa:	6605                	lui	a2,0x1
    800008fc:	85ca                	mv	a1,s2
    800008fe:	8556                	mv	a0,s5
    80000900:	00000097          	auipc	ra,0x0
    80000904:	c40080e7          	jalr	-960(ra) # 80000540 <mappages>
    80000908:	e905                	bnez	a0,80000938 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000090a:	6785                	lui	a5,0x1
    8000090c:	993e                	add	s2,s2,a5
    8000090e:	fd4968e3          	bltu	s2,s4,800008de <uvmalloc+0x2c>
  return newsz;
    80000912:	8552                	mv	a0,s4
    80000914:	a809                	j	80000926 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000916:	864e                	mv	a2,s3
    80000918:	85ca                	mv	a1,s2
    8000091a:	8556                	mv	a0,s5
    8000091c:	00000097          	auipc	ra,0x0
    80000920:	f4e080e7          	jalr	-178(ra) # 8000086a <uvmdealloc>
      return 0;
    80000924:	4501                	li	a0,0
}
    80000926:	70e2                	ld	ra,56(sp)
    80000928:	7442                	ld	s0,48(sp)
    8000092a:	74a2                	ld	s1,40(sp)
    8000092c:	7902                	ld	s2,32(sp)
    8000092e:	69e2                	ld	s3,24(sp)
    80000930:	6a42                	ld	s4,16(sp)
    80000932:	6aa2                	ld	s5,8(sp)
    80000934:	6121                	addi	sp,sp,64
    80000936:	8082                	ret
      kfree(mem);
    80000938:	8526                	mv	a0,s1
    8000093a:	fffff097          	auipc	ra,0xfffff
    8000093e:	6e2080e7          	jalr	1762(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000942:	864e                	mv	a2,s3
    80000944:	85ca                	mv	a1,s2
    80000946:	8556                	mv	a0,s5
    80000948:	00000097          	auipc	ra,0x0
    8000094c:	f22080e7          	jalr	-222(ra) # 8000086a <uvmdealloc>
      return 0;
    80000950:	4501                	li	a0,0
    80000952:	bfd1                	j	80000926 <uvmalloc+0x74>
    return oldsz;
    80000954:	852e                	mv	a0,a1
}
    80000956:	8082                	ret
  return newsz;
    80000958:	8532                	mv	a0,a2
    8000095a:	b7f1                	j	80000926 <uvmalloc+0x74>

000000008000095c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000095c:	7179                	addi	sp,sp,-48
    8000095e:	f406                	sd	ra,40(sp)
    80000960:	f022                	sd	s0,32(sp)
    80000962:	ec26                	sd	s1,24(sp)
    80000964:	e84a                	sd	s2,16(sp)
    80000966:	e44e                	sd	s3,8(sp)
    80000968:	e052                	sd	s4,0(sp)
    8000096a:	1800                	addi	s0,sp,48
    8000096c:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000096e:	84aa                	mv	s1,a0
    80000970:	6905                	lui	s2,0x1
    80000972:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000974:	4985                	li	s3,1
    80000976:	a821                	j	8000098e <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000978:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    8000097a:	0532                	slli	a0,a0,0xc
    8000097c:	00000097          	auipc	ra,0x0
    80000980:	fe0080e7          	jalr	-32(ra) # 8000095c <freewalk>
      pagetable[i] = 0;
    80000984:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000988:	04a1                	addi	s1,s1,8
    8000098a:	03248163          	beq	s1,s2,800009ac <freewalk+0x50>
    pte_t pte = pagetable[i];
    8000098e:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000990:	00f57793          	andi	a5,a0,15
    80000994:	ff3782e3          	beq	a5,s3,80000978 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000998:	8905                	andi	a0,a0,1
    8000099a:	d57d                	beqz	a0,80000988 <freewalk+0x2c>
      panic("freewalk: leaf");
    8000099c:	00007517          	auipc	a0,0x7
    800009a0:	75c50513          	addi	a0,a0,1884 # 800080f8 <etext+0xf8>
    800009a4:	00005097          	auipc	ra,0x5
    800009a8:	130080e7          	jalr	304(ra) # 80005ad4 <panic>
    }
  }
  kfree((void*)pagetable);
    800009ac:	8552                	mv	a0,s4
    800009ae:	fffff097          	auipc	ra,0xfffff
    800009b2:	66e080e7          	jalr	1646(ra) # 8000001c <kfree>
}
    800009b6:	70a2                	ld	ra,40(sp)
    800009b8:	7402                	ld	s0,32(sp)
    800009ba:	64e2                	ld	s1,24(sp)
    800009bc:	6942                	ld	s2,16(sp)
    800009be:	69a2                	ld	s3,8(sp)
    800009c0:	6a02                	ld	s4,0(sp)
    800009c2:	6145                	addi	sp,sp,48
    800009c4:	8082                	ret

00000000800009c6 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009c6:	1101                	addi	sp,sp,-32
    800009c8:	ec06                	sd	ra,24(sp)
    800009ca:	e822                	sd	s0,16(sp)
    800009cc:	e426                	sd	s1,8(sp)
    800009ce:	1000                	addi	s0,sp,32
    800009d0:	84aa                	mv	s1,a0
  if(sz > 0)
    800009d2:	e999                	bnez	a1,800009e8 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009d4:	8526                	mv	a0,s1
    800009d6:	00000097          	auipc	ra,0x0
    800009da:	f86080e7          	jalr	-122(ra) # 8000095c <freewalk>
}
    800009de:	60e2                	ld	ra,24(sp)
    800009e0:	6442                	ld	s0,16(sp)
    800009e2:	64a2                	ld	s1,8(sp)
    800009e4:	6105                	addi	sp,sp,32
    800009e6:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009e8:	6605                	lui	a2,0x1
    800009ea:	167d                	addi	a2,a2,-1
    800009ec:	962e                	add	a2,a2,a1
    800009ee:	4685                	li	a3,1
    800009f0:	8231                	srli	a2,a2,0xc
    800009f2:	4581                	li	a1,0
    800009f4:	00000097          	auipc	ra,0x0
    800009f8:	d12080e7          	jalr	-750(ra) # 80000706 <uvmunmap>
    800009fc:	bfe1                	j	800009d4 <uvmfree+0xe>

00000000800009fe <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800009fe:	c679                	beqz	a2,80000acc <uvmcopy+0xce>
{
    80000a00:	715d                	addi	sp,sp,-80
    80000a02:	e486                	sd	ra,72(sp)
    80000a04:	e0a2                	sd	s0,64(sp)
    80000a06:	fc26                	sd	s1,56(sp)
    80000a08:	f84a                	sd	s2,48(sp)
    80000a0a:	f44e                	sd	s3,40(sp)
    80000a0c:	f052                	sd	s4,32(sp)
    80000a0e:	ec56                	sd	s5,24(sp)
    80000a10:	e85a                	sd	s6,16(sp)
    80000a12:	e45e                	sd	s7,8(sp)
    80000a14:	0880                	addi	s0,sp,80
    80000a16:	8b2a                	mv	s6,a0
    80000a18:	8aae                	mv	s5,a1
    80000a1a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a1c:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a1e:	4601                	li	a2,0
    80000a20:	85ce                	mv	a1,s3
    80000a22:	855a                	mv	a0,s6
    80000a24:	00000097          	auipc	ra,0x0
    80000a28:	a34080e7          	jalr	-1484(ra) # 80000458 <walk>
    80000a2c:	c531                	beqz	a0,80000a78 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a2e:	6118                	ld	a4,0(a0)
    80000a30:	00177793          	andi	a5,a4,1
    80000a34:	cbb1                	beqz	a5,80000a88 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a36:	00a75593          	srli	a1,a4,0xa
    80000a3a:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a3e:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a42:	fffff097          	auipc	ra,0xfffff
    80000a46:	6d6080e7          	jalr	1750(ra) # 80000118 <kalloc>
    80000a4a:	892a                	mv	s2,a0
    80000a4c:	c939                	beqz	a0,80000aa2 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a4e:	6605                	lui	a2,0x1
    80000a50:	85de                	mv	a1,s7
    80000a52:	fffff097          	auipc	ra,0xfffff
    80000a56:	782080e7          	jalr	1922(ra) # 800001d4 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a5a:	8726                	mv	a4,s1
    80000a5c:	86ca                	mv	a3,s2
    80000a5e:	6605                	lui	a2,0x1
    80000a60:	85ce                	mv	a1,s3
    80000a62:	8556                	mv	a0,s5
    80000a64:	00000097          	auipc	ra,0x0
    80000a68:	adc080e7          	jalr	-1316(ra) # 80000540 <mappages>
    80000a6c:	e515                	bnez	a0,80000a98 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a6e:	6785                	lui	a5,0x1
    80000a70:	99be                	add	s3,s3,a5
    80000a72:	fb49e6e3          	bltu	s3,s4,80000a1e <uvmcopy+0x20>
    80000a76:	a081                	j	80000ab6 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a78:	00007517          	auipc	a0,0x7
    80000a7c:	69050513          	addi	a0,a0,1680 # 80008108 <etext+0x108>
    80000a80:	00005097          	auipc	ra,0x5
    80000a84:	054080e7          	jalr	84(ra) # 80005ad4 <panic>
      panic("uvmcopy: page not present");
    80000a88:	00007517          	auipc	a0,0x7
    80000a8c:	6a050513          	addi	a0,a0,1696 # 80008128 <etext+0x128>
    80000a90:	00005097          	auipc	ra,0x5
    80000a94:	044080e7          	jalr	68(ra) # 80005ad4 <panic>
      kfree(mem);
    80000a98:	854a                	mv	a0,s2
    80000a9a:	fffff097          	auipc	ra,0xfffff
    80000a9e:	582080e7          	jalr	1410(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aa2:	4685                	li	a3,1
    80000aa4:	00c9d613          	srli	a2,s3,0xc
    80000aa8:	4581                	li	a1,0
    80000aaa:	8556                	mv	a0,s5
    80000aac:	00000097          	auipc	ra,0x0
    80000ab0:	c5a080e7          	jalr	-934(ra) # 80000706 <uvmunmap>
  return -1;
    80000ab4:	557d                	li	a0,-1
}
    80000ab6:	60a6                	ld	ra,72(sp)
    80000ab8:	6406                	ld	s0,64(sp)
    80000aba:	74e2                	ld	s1,56(sp)
    80000abc:	7942                	ld	s2,48(sp)
    80000abe:	79a2                	ld	s3,40(sp)
    80000ac0:	7a02                	ld	s4,32(sp)
    80000ac2:	6ae2                	ld	s5,24(sp)
    80000ac4:	6b42                	ld	s6,16(sp)
    80000ac6:	6ba2                	ld	s7,8(sp)
    80000ac8:	6161                	addi	sp,sp,80
    80000aca:	8082                	ret
  return 0;
    80000acc:	4501                	li	a0,0
}
    80000ace:	8082                	ret

0000000080000ad0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ad0:	1141                	addi	sp,sp,-16
    80000ad2:	e406                	sd	ra,8(sp)
    80000ad4:	e022                	sd	s0,0(sp)
    80000ad6:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ad8:	4601                	li	a2,0
    80000ada:	00000097          	auipc	ra,0x0
    80000ade:	97e080e7          	jalr	-1666(ra) # 80000458 <walk>
  if(pte == 0)
    80000ae2:	c901                	beqz	a0,80000af2 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000ae4:	611c                	ld	a5,0(a0)
    80000ae6:	9bbd                	andi	a5,a5,-17
    80000ae8:	e11c                	sd	a5,0(a0)
}
    80000aea:	60a2                	ld	ra,8(sp)
    80000aec:	6402                	ld	s0,0(sp)
    80000aee:	0141                	addi	sp,sp,16
    80000af0:	8082                	ret
    panic("uvmclear");
    80000af2:	00007517          	auipc	a0,0x7
    80000af6:	65650513          	addi	a0,a0,1622 # 80008148 <etext+0x148>
    80000afa:	00005097          	auipc	ra,0x5
    80000afe:	fda080e7          	jalr	-38(ra) # 80005ad4 <panic>

0000000080000b02 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b02:	c6bd                	beqz	a3,80000b70 <copyout+0x6e>
{
    80000b04:	715d                	addi	sp,sp,-80
    80000b06:	e486                	sd	ra,72(sp)
    80000b08:	e0a2                	sd	s0,64(sp)
    80000b0a:	fc26                	sd	s1,56(sp)
    80000b0c:	f84a                	sd	s2,48(sp)
    80000b0e:	f44e                	sd	s3,40(sp)
    80000b10:	f052                	sd	s4,32(sp)
    80000b12:	ec56                	sd	s5,24(sp)
    80000b14:	e85a                	sd	s6,16(sp)
    80000b16:	e45e                	sd	s7,8(sp)
    80000b18:	e062                	sd	s8,0(sp)
    80000b1a:	0880                	addi	s0,sp,80
    80000b1c:	8b2a                	mv	s6,a0
    80000b1e:	8c2e                	mv	s8,a1
    80000b20:	8a32                	mv	s4,a2
    80000b22:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b24:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b26:	6a85                	lui	s5,0x1
    80000b28:	a015                	j	80000b4c <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b2a:	9562                	add	a0,a0,s8
    80000b2c:	0004861b          	sext.w	a2,s1
    80000b30:	85d2                	mv	a1,s4
    80000b32:	41250533          	sub	a0,a0,s2
    80000b36:	fffff097          	auipc	ra,0xfffff
    80000b3a:	69e080e7          	jalr	1694(ra) # 800001d4 <memmove>

    len -= n;
    80000b3e:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b42:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b44:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b48:	02098263          	beqz	s3,80000b6c <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b4c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b50:	85ca                	mv	a1,s2
    80000b52:	855a                	mv	a0,s6
    80000b54:	00000097          	auipc	ra,0x0
    80000b58:	9aa080e7          	jalr	-1622(ra) # 800004fe <walkaddr>
    if(pa0 == 0)
    80000b5c:	cd01                	beqz	a0,80000b74 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b5e:	418904b3          	sub	s1,s2,s8
    80000b62:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b64:	fc99f3e3          	bgeu	s3,s1,80000b2a <copyout+0x28>
    80000b68:	84ce                	mv	s1,s3
    80000b6a:	b7c1                	j	80000b2a <copyout+0x28>
  }
  return 0;
    80000b6c:	4501                	li	a0,0
    80000b6e:	a021                	j	80000b76 <copyout+0x74>
    80000b70:	4501                	li	a0,0
}
    80000b72:	8082                	ret
      return -1;
    80000b74:	557d                	li	a0,-1
}
    80000b76:	60a6                	ld	ra,72(sp)
    80000b78:	6406                	ld	s0,64(sp)
    80000b7a:	74e2                	ld	s1,56(sp)
    80000b7c:	7942                	ld	s2,48(sp)
    80000b7e:	79a2                	ld	s3,40(sp)
    80000b80:	7a02                	ld	s4,32(sp)
    80000b82:	6ae2                	ld	s5,24(sp)
    80000b84:	6b42                	ld	s6,16(sp)
    80000b86:	6ba2                	ld	s7,8(sp)
    80000b88:	6c02                	ld	s8,0(sp)
    80000b8a:	6161                	addi	sp,sp,80
    80000b8c:	8082                	ret

0000000080000b8e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b8e:	caa5                	beqz	a3,80000bfe <copyin+0x70>
{
    80000b90:	715d                	addi	sp,sp,-80
    80000b92:	e486                	sd	ra,72(sp)
    80000b94:	e0a2                	sd	s0,64(sp)
    80000b96:	fc26                	sd	s1,56(sp)
    80000b98:	f84a                	sd	s2,48(sp)
    80000b9a:	f44e                	sd	s3,40(sp)
    80000b9c:	f052                	sd	s4,32(sp)
    80000b9e:	ec56                	sd	s5,24(sp)
    80000ba0:	e85a                	sd	s6,16(sp)
    80000ba2:	e45e                	sd	s7,8(sp)
    80000ba4:	e062                	sd	s8,0(sp)
    80000ba6:	0880                	addi	s0,sp,80
    80000ba8:	8b2a                	mv	s6,a0
    80000baa:	8a2e                	mv	s4,a1
    80000bac:	8c32                	mv	s8,a2
    80000bae:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bb0:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bb2:	6a85                	lui	s5,0x1
    80000bb4:	a01d                	j	80000bda <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bb6:	018505b3          	add	a1,a0,s8
    80000bba:	0004861b          	sext.w	a2,s1
    80000bbe:	412585b3          	sub	a1,a1,s2
    80000bc2:	8552                	mv	a0,s4
    80000bc4:	fffff097          	auipc	ra,0xfffff
    80000bc8:	610080e7          	jalr	1552(ra) # 800001d4 <memmove>

    len -= n;
    80000bcc:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bd0:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bd2:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bd6:	02098263          	beqz	s3,80000bfa <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000bda:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bde:	85ca                	mv	a1,s2
    80000be0:	855a                	mv	a0,s6
    80000be2:	00000097          	auipc	ra,0x0
    80000be6:	91c080e7          	jalr	-1764(ra) # 800004fe <walkaddr>
    if(pa0 == 0)
    80000bea:	cd01                	beqz	a0,80000c02 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bec:	418904b3          	sub	s1,s2,s8
    80000bf0:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bf2:	fc99f2e3          	bgeu	s3,s1,80000bb6 <copyin+0x28>
    80000bf6:	84ce                	mv	s1,s3
    80000bf8:	bf7d                	j	80000bb6 <copyin+0x28>
  }
  return 0;
    80000bfa:	4501                	li	a0,0
    80000bfc:	a021                	j	80000c04 <copyin+0x76>
    80000bfe:	4501                	li	a0,0
}
    80000c00:	8082                	ret
      return -1;
    80000c02:	557d                	li	a0,-1
}
    80000c04:	60a6                	ld	ra,72(sp)
    80000c06:	6406                	ld	s0,64(sp)
    80000c08:	74e2                	ld	s1,56(sp)
    80000c0a:	7942                	ld	s2,48(sp)
    80000c0c:	79a2                	ld	s3,40(sp)
    80000c0e:	7a02                	ld	s4,32(sp)
    80000c10:	6ae2                	ld	s5,24(sp)
    80000c12:	6b42                	ld	s6,16(sp)
    80000c14:	6ba2                	ld	s7,8(sp)
    80000c16:	6c02                	ld	s8,0(sp)
    80000c18:	6161                	addi	sp,sp,80
    80000c1a:	8082                	ret

0000000080000c1c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c1c:	c6c5                	beqz	a3,80000cc4 <copyinstr+0xa8>
{
    80000c1e:	715d                	addi	sp,sp,-80
    80000c20:	e486                	sd	ra,72(sp)
    80000c22:	e0a2                	sd	s0,64(sp)
    80000c24:	fc26                	sd	s1,56(sp)
    80000c26:	f84a                	sd	s2,48(sp)
    80000c28:	f44e                	sd	s3,40(sp)
    80000c2a:	f052                	sd	s4,32(sp)
    80000c2c:	ec56                	sd	s5,24(sp)
    80000c2e:	e85a                	sd	s6,16(sp)
    80000c30:	e45e                	sd	s7,8(sp)
    80000c32:	0880                	addi	s0,sp,80
    80000c34:	8a2a                	mv	s4,a0
    80000c36:	8b2e                	mv	s6,a1
    80000c38:	8bb2                	mv	s7,a2
    80000c3a:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c3c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c3e:	6985                	lui	s3,0x1
    80000c40:	a035                	j	80000c6c <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c42:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c46:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c48:	0017b793          	seqz	a5,a5
    80000c4c:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c50:	60a6                	ld	ra,72(sp)
    80000c52:	6406                	ld	s0,64(sp)
    80000c54:	74e2                	ld	s1,56(sp)
    80000c56:	7942                	ld	s2,48(sp)
    80000c58:	79a2                	ld	s3,40(sp)
    80000c5a:	7a02                	ld	s4,32(sp)
    80000c5c:	6ae2                	ld	s5,24(sp)
    80000c5e:	6b42                	ld	s6,16(sp)
    80000c60:	6ba2                	ld	s7,8(sp)
    80000c62:	6161                	addi	sp,sp,80
    80000c64:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c66:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c6a:	c8a9                	beqz	s1,80000cbc <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c6c:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c70:	85ca                	mv	a1,s2
    80000c72:	8552                	mv	a0,s4
    80000c74:	00000097          	auipc	ra,0x0
    80000c78:	88a080e7          	jalr	-1910(ra) # 800004fe <walkaddr>
    if(pa0 == 0)
    80000c7c:	c131                	beqz	a0,80000cc0 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c7e:	41790833          	sub	a6,s2,s7
    80000c82:	984e                	add	a6,a6,s3
    if(n > max)
    80000c84:	0104f363          	bgeu	s1,a6,80000c8a <copyinstr+0x6e>
    80000c88:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c8a:	955e                	add	a0,a0,s7
    80000c8c:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c90:	fc080be3          	beqz	a6,80000c66 <copyinstr+0x4a>
    80000c94:	985a                	add	a6,a6,s6
    80000c96:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c98:	41650633          	sub	a2,a0,s6
    80000c9c:	14fd                	addi	s1,s1,-1
    80000c9e:	9b26                	add	s6,s6,s1
    80000ca0:	00f60733          	add	a4,a2,a5
    80000ca4:	00074703          	lbu	a4,0(a4)
    80000ca8:	df49                	beqz	a4,80000c42 <copyinstr+0x26>
        *dst = *p;
    80000caa:	00e78023          	sb	a4,0(a5)
      --max;
    80000cae:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cb2:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cb4:	ff0796e3          	bne	a5,a6,80000ca0 <copyinstr+0x84>
      dst++;
    80000cb8:	8b42                	mv	s6,a6
    80000cba:	b775                	j	80000c66 <copyinstr+0x4a>
    80000cbc:	4781                	li	a5,0
    80000cbe:	b769                	j	80000c48 <copyinstr+0x2c>
      return -1;
    80000cc0:	557d                	li	a0,-1
    80000cc2:	b779                	j	80000c50 <copyinstr+0x34>
  int got_null = 0;
    80000cc4:	4781                	li	a5,0
  if(got_null){
    80000cc6:	0017b793          	seqz	a5,a5
    80000cca:	40f00533          	neg	a0,a5
}
    80000cce:	8082                	ret

0000000080000cd0 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cd0:	7139                	addi	sp,sp,-64
    80000cd2:	fc06                	sd	ra,56(sp)
    80000cd4:	f822                	sd	s0,48(sp)
    80000cd6:	f426                	sd	s1,40(sp)
    80000cd8:	f04a                	sd	s2,32(sp)
    80000cda:	ec4e                	sd	s3,24(sp)
    80000cdc:	e852                	sd	s4,16(sp)
    80000cde:	e456                	sd	s5,8(sp)
    80000ce0:	e05a                	sd	s6,0(sp)
    80000ce2:	0080                	addi	s0,sp,64
    80000ce4:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ce6:	00008497          	auipc	s1,0x8
    80000cea:	79a48493          	addi	s1,s1,1946 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cee:	8b26                	mv	s6,s1
    80000cf0:	00007a97          	auipc	s5,0x7
    80000cf4:	310a8a93          	addi	s5,s5,784 # 80008000 <etext>
    80000cf8:	04000937          	lui	s2,0x4000
    80000cfc:	197d                	addi	s2,s2,-1
    80000cfe:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d00:	0000ea17          	auipc	s4,0xe
    80000d04:	180a0a13          	addi	s4,s4,384 # 8000ee80 <tickslock>
    char *pa = kalloc();
    80000d08:	fffff097          	auipc	ra,0xfffff
    80000d0c:	410080e7          	jalr	1040(ra) # 80000118 <kalloc>
    80000d10:	862a                	mv	a2,a0
    if(pa == 0)
    80000d12:	c131                	beqz	a0,80000d56 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d14:	416485b3          	sub	a1,s1,s6
    80000d18:	858d                	srai	a1,a1,0x3
    80000d1a:	000ab783          	ld	a5,0(s5)
    80000d1e:	02f585b3          	mul	a1,a1,a5
    80000d22:	2585                	addiw	a1,a1,1
    80000d24:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d28:	4719                	li	a4,6
    80000d2a:	6685                	lui	a3,0x1
    80000d2c:	40b905b3          	sub	a1,s2,a1
    80000d30:	854e                	mv	a0,s3
    80000d32:	00000097          	auipc	ra,0x0
    80000d36:	8ae080e7          	jalr	-1874(ra) # 800005e0 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d3a:	16848493          	addi	s1,s1,360
    80000d3e:	fd4495e3          	bne	s1,s4,80000d08 <proc_mapstacks+0x38>
  }
}
    80000d42:	70e2                	ld	ra,56(sp)
    80000d44:	7442                	ld	s0,48(sp)
    80000d46:	74a2                	ld	s1,40(sp)
    80000d48:	7902                	ld	s2,32(sp)
    80000d4a:	69e2                	ld	s3,24(sp)
    80000d4c:	6a42                	ld	s4,16(sp)
    80000d4e:	6aa2                	ld	s5,8(sp)
    80000d50:	6b02                	ld	s6,0(sp)
    80000d52:	6121                	addi	sp,sp,64
    80000d54:	8082                	ret
      panic("kalloc");
    80000d56:	00007517          	auipc	a0,0x7
    80000d5a:	40250513          	addi	a0,a0,1026 # 80008158 <etext+0x158>
    80000d5e:	00005097          	auipc	ra,0x5
    80000d62:	d76080e7          	jalr	-650(ra) # 80005ad4 <panic>

0000000080000d66 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d66:	7139                	addi	sp,sp,-64
    80000d68:	fc06                	sd	ra,56(sp)
    80000d6a:	f822                	sd	s0,48(sp)
    80000d6c:	f426                	sd	s1,40(sp)
    80000d6e:	f04a                	sd	s2,32(sp)
    80000d70:	ec4e                	sd	s3,24(sp)
    80000d72:	e852                	sd	s4,16(sp)
    80000d74:	e456                	sd	s5,8(sp)
    80000d76:	e05a                	sd	s6,0(sp)
    80000d78:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d7a:	00007597          	auipc	a1,0x7
    80000d7e:	3e658593          	addi	a1,a1,998 # 80008160 <etext+0x160>
    80000d82:	00008517          	auipc	a0,0x8
    80000d86:	2ce50513          	addi	a0,a0,718 # 80009050 <pid_lock>
    80000d8a:	00005097          	auipc	ra,0x5
    80000d8e:	1f6080e7          	jalr	502(ra) # 80005f80 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d92:	00007597          	auipc	a1,0x7
    80000d96:	3d658593          	addi	a1,a1,982 # 80008168 <etext+0x168>
    80000d9a:	00008517          	auipc	a0,0x8
    80000d9e:	2ce50513          	addi	a0,a0,718 # 80009068 <wait_lock>
    80000da2:	00005097          	auipc	ra,0x5
    80000da6:	1de080e7          	jalr	478(ra) # 80005f80 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000daa:	00008497          	auipc	s1,0x8
    80000dae:	6d648493          	addi	s1,s1,1750 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000db2:	00007b17          	auipc	s6,0x7
    80000db6:	3c6b0b13          	addi	s6,s6,966 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000dba:	8aa6                	mv	s5,s1
    80000dbc:	00007a17          	auipc	s4,0x7
    80000dc0:	244a0a13          	addi	s4,s4,580 # 80008000 <etext>
    80000dc4:	04000937          	lui	s2,0x4000
    80000dc8:	197d                	addi	s2,s2,-1
    80000dca:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dcc:	0000e997          	auipc	s3,0xe
    80000dd0:	0b498993          	addi	s3,s3,180 # 8000ee80 <tickslock>
      initlock(&p->lock, "proc");
    80000dd4:	85da                	mv	a1,s6
    80000dd6:	8526                	mv	a0,s1
    80000dd8:	00005097          	auipc	ra,0x5
    80000ddc:	1a8080e7          	jalr	424(ra) # 80005f80 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000de0:	415487b3          	sub	a5,s1,s5
    80000de4:	878d                	srai	a5,a5,0x3
    80000de6:	000a3703          	ld	a4,0(s4)
    80000dea:	02e787b3          	mul	a5,a5,a4
    80000dee:	2785                	addiw	a5,a5,1
    80000df0:	00d7979b          	slliw	a5,a5,0xd
    80000df4:	40f907b3          	sub	a5,s2,a5
    80000df8:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dfa:	16848493          	addi	s1,s1,360
    80000dfe:	fd349be3          	bne	s1,s3,80000dd4 <procinit+0x6e>
  }
}
    80000e02:	70e2                	ld	ra,56(sp)
    80000e04:	7442                	ld	s0,48(sp)
    80000e06:	74a2                	ld	s1,40(sp)
    80000e08:	7902                	ld	s2,32(sp)
    80000e0a:	69e2                	ld	s3,24(sp)
    80000e0c:	6a42                	ld	s4,16(sp)
    80000e0e:	6aa2                	ld	s5,8(sp)
    80000e10:	6b02                	ld	s6,0(sp)
    80000e12:	6121                	addi	sp,sp,64
    80000e14:	8082                	ret

0000000080000e16 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e16:	1141                	addi	sp,sp,-16
    80000e18:	e422                	sd	s0,8(sp)
    80000e1a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e1c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e1e:	2501                	sext.w	a0,a0
    80000e20:	6422                	ld	s0,8(sp)
    80000e22:	0141                	addi	sp,sp,16
    80000e24:	8082                	ret

0000000080000e26 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e26:	1141                	addi	sp,sp,-16
    80000e28:	e422                	sd	s0,8(sp)
    80000e2a:	0800                	addi	s0,sp,16
    80000e2c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e2e:	2781                	sext.w	a5,a5
    80000e30:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e32:	00008517          	auipc	a0,0x8
    80000e36:	24e50513          	addi	a0,a0,590 # 80009080 <cpus>
    80000e3a:	953e                	add	a0,a0,a5
    80000e3c:	6422                	ld	s0,8(sp)
    80000e3e:	0141                	addi	sp,sp,16
    80000e40:	8082                	ret

0000000080000e42 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e42:	1101                	addi	sp,sp,-32
    80000e44:	ec06                	sd	ra,24(sp)
    80000e46:	e822                	sd	s0,16(sp)
    80000e48:	e426                	sd	s1,8(sp)
    80000e4a:	1000                	addi	s0,sp,32
  push_off();
    80000e4c:	00005097          	auipc	ra,0x5
    80000e50:	178080e7          	jalr	376(ra) # 80005fc4 <push_off>
    80000e54:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e56:	2781                	sext.w	a5,a5
    80000e58:	079e                	slli	a5,a5,0x7
    80000e5a:	00008717          	auipc	a4,0x8
    80000e5e:	1f670713          	addi	a4,a4,502 # 80009050 <pid_lock>
    80000e62:	97ba                	add	a5,a5,a4
    80000e64:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e66:	00005097          	auipc	ra,0x5
    80000e6a:	1fe080e7          	jalr	510(ra) # 80006064 <pop_off>
  return p;
}
    80000e6e:	8526                	mv	a0,s1
    80000e70:	60e2                	ld	ra,24(sp)
    80000e72:	6442                	ld	s0,16(sp)
    80000e74:	64a2                	ld	s1,8(sp)
    80000e76:	6105                	addi	sp,sp,32
    80000e78:	8082                	ret

0000000080000e7a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e7a:	1141                	addi	sp,sp,-16
    80000e7c:	e406                	sd	ra,8(sp)
    80000e7e:	e022                	sd	s0,0(sp)
    80000e80:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e82:	00000097          	auipc	ra,0x0
    80000e86:	fc0080e7          	jalr	-64(ra) # 80000e42 <myproc>
    80000e8a:	00005097          	auipc	ra,0x5
    80000e8e:	23a080e7          	jalr	570(ra) # 800060c4 <release>

  if (first) {
    80000e92:	00008797          	auipc	a5,0x8
    80000e96:	97e7a783          	lw	a5,-1666(a5) # 80008810 <first.1>
    80000e9a:	eb89                	bnez	a5,80000eac <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000e9c:	00001097          	auipc	ra,0x1
    80000ea0:	c0e080e7          	jalr	-1010(ra) # 80001aaa <usertrapret>
}
    80000ea4:	60a2                	ld	ra,8(sp)
    80000ea6:	6402                	ld	s0,0(sp)
    80000ea8:	0141                	addi	sp,sp,16
    80000eaa:	8082                	ret
    first = 0;
    80000eac:	00008797          	auipc	a5,0x8
    80000eb0:	9607a223          	sw	zero,-1692(a5) # 80008810 <first.1>
    fsinit(ROOTDEV);
    80000eb4:	4505                	li	a0,1
    80000eb6:	00002097          	auipc	ra,0x2
    80000eba:	934080e7          	jalr	-1740(ra) # 800027ea <fsinit>
    80000ebe:	bff9                	j	80000e9c <forkret+0x22>

0000000080000ec0 <allocpid>:
allocpid() {
    80000ec0:	1101                	addi	sp,sp,-32
    80000ec2:	ec06                	sd	ra,24(sp)
    80000ec4:	e822                	sd	s0,16(sp)
    80000ec6:	e426                	sd	s1,8(sp)
    80000ec8:	e04a                	sd	s2,0(sp)
    80000eca:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ecc:	00008917          	auipc	s2,0x8
    80000ed0:	18490913          	addi	s2,s2,388 # 80009050 <pid_lock>
    80000ed4:	854a                	mv	a0,s2
    80000ed6:	00005097          	auipc	ra,0x5
    80000eda:	13a080e7          	jalr	314(ra) # 80006010 <acquire>
  pid = nextpid;
    80000ede:	00008797          	auipc	a5,0x8
    80000ee2:	93678793          	addi	a5,a5,-1738 # 80008814 <nextpid>
    80000ee6:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ee8:	0014871b          	addiw	a4,s1,1
    80000eec:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000eee:	854a                	mv	a0,s2
    80000ef0:	00005097          	auipc	ra,0x5
    80000ef4:	1d4080e7          	jalr	468(ra) # 800060c4 <release>
}
    80000ef8:	8526                	mv	a0,s1
    80000efa:	60e2                	ld	ra,24(sp)
    80000efc:	6442                	ld	s0,16(sp)
    80000efe:	64a2                	ld	s1,8(sp)
    80000f00:	6902                	ld	s2,0(sp)
    80000f02:	6105                	addi	sp,sp,32
    80000f04:	8082                	ret

0000000080000f06 <proc_pagetable>:
{
    80000f06:	1101                	addi	sp,sp,-32
    80000f08:	ec06                	sd	ra,24(sp)
    80000f0a:	e822                	sd	s0,16(sp)
    80000f0c:	e426                	sd	s1,8(sp)
    80000f0e:	e04a                	sd	s2,0(sp)
    80000f10:	1000                	addi	s0,sp,32
    80000f12:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f14:	00000097          	auipc	ra,0x0
    80000f18:	8b6080e7          	jalr	-1866(ra) # 800007ca <uvmcreate>
    80000f1c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f1e:	c121                	beqz	a0,80000f5e <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f20:	4729                	li	a4,10
    80000f22:	00006697          	auipc	a3,0x6
    80000f26:	0de68693          	addi	a3,a3,222 # 80007000 <_trampoline>
    80000f2a:	6605                	lui	a2,0x1
    80000f2c:	040005b7          	lui	a1,0x4000
    80000f30:	15fd                	addi	a1,a1,-1
    80000f32:	05b2                	slli	a1,a1,0xc
    80000f34:	fffff097          	auipc	ra,0xfffff
    80000f38:	60c080e7          	jalr	1548(ra) # 80000540 <mappages>
    80000f3c:	02054863          	bltz	a0,80000f6c <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f40:	4719                	li	a4,6
    80000f42:	05893683          	ld	a3,88(s2)
    80000f46:	6605                	lui	a2,0x1
    80000f48:	020005b7          	lui	a1,0x2000
    80000f4c:	15fd                	addi	a1,a1,-1
    80000f4e:	05b6                	slli	a1,a1,0xd
    80000f50:	8526                	mv	a0,s1
    80000f52:	fffff097          	auipc	ra,0xfffff
    80000f56:	5ee080e7          	jalr	1518(ra) # 80000540 <mappages>
    80000f5a:	02054163          	bltz	a0,80000f7c <proc_pagetable+0x76>
}
    80000f5e:	8526                	mv	a0,s1
    80000f60:	60e2                	ld	ra,24(sp)
    80000f62:	6442                	ld	s0,16(sp)
    80000f64:	64a2                	ld	s1,8(sp)
    80000f66:	6902                	ld	s2,0(sp)
    80000f68:	6105                	addi	sp,sp,32
    80000f6a:	8082                	ret
    uvmfree(pagetable, 0);
    80000f6c:	4581                	li	a1,0
    80000f6e:	8526                	mv	a0,s1
    80000f70:	00000097          	auipc	ra,0x0
    80000f74:	a56080e7          	jalr	-1450(ra) # 800009c6 <uvmfree>
    return 0;
    80000f78:	4481                	li	s1,0
    80000f7a:	b7d5                	j	80000f5e <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f7c:	4681                	li	a3,0
    80000f7e:	4605                	li	a2,1
    80000f80:	040005b7          	lui	a1,0x4000
    80000f84:	15fd                	addi	a1,a1,-1
    80000f86:	05b2                	slli	a1,a1,0xc
    80000f88:	8526                	mv	a0,s1
    80000f8a:	fffff097          	auipc	ra,0xfffff
    80000f8e:	77c080e7          	jalr	1916(ra) # 80000706 <uvmunmap>
    uvmfree(pagetable, 0);
    80000f92:	4581                	li	a1,0
    80000f94:	8526                	mv	a0,s1
    80000f96:	00000097          	auipc	ra,0x0
    80000f9a:	a30080e7          	jalr	-1488(ra) # 800009c6 <uvmfree>
    return 0;
    80000f9e:	4481                	li	s1,0
    80000fa0:	bf7d                	j	80000f5e <proc_pagetable+0x58>

0000000080000fa2 <proc_freepagetable>:
{
    80000fa2:	1101                	addi	sp,sp,-32
    80000fa4:	ec06                	sd	ra,24(sp)
    80000fa6:	e822                	sd	s0,16(sp)
    80000fa8:	e426                	sd	s1,8(sp)
    80000faa:	e04a                	sd	s2,0(sp)
    80000fac:	1000                	addi	s0,sp,32
    80000fae:	84aa                	mv	s1,a0
    80000fb0:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb2:	4681                	li	a3,0
    80000fb4:	4605                	li	a2,1
    80000fb6:	040005b7          	lui	a1,0x4000
    80000fba:	15fd                	addi	a1,a1,-1
    80000fbc:	05b2                	slli	a1,a1,0xc
    80000fbe:	fffff097          	auipc	ra,0xfffff
    80000fc2:	748080e7          	jalr	1864(ra) # 80000706 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fc6:	4681                	li	a3,0
    80000fc8:	4605                	li	a2,1
    80000fca:	020005b7          	lui	a1,0x2000
    80000fce:	15fd                	addi	a1,a1,-1
    80000fd0:	05b6                	slli	a1,a1,0xd
    80000fd2:	8526                	mv	a0,s1
    80000fd4:	fffff097          	auipc	ra,0xfffff
    80000fd8:	732080e7          	jalr	1842(ra) # 80000706 <uvmunmap>
  uvmfree(pagetable, sz);
    80000fdc:	85ca                	mv	a1,s2
    80000fde:	8526                	mv	a0,s1
    80000fe0:	00000097          	auipc	ra,0x0
    80000fe4:	9e6080e7          	jalr	-1562(ra) # 800009c6 <uvmfree>
}
    80000fe8:	60e2                	ld	ra,24(sp)
    80000fea:	6442                	ld	s0,16(sp)
    80000fec:	64a2                	ld	s1,8(sp)
    80000fee:	6902                	ld	s2,0(sp)
    80000ff0:	6105                	addi	sp,sp,32
    80000ff2:	8082                	ret

0000000080000ff4 <freeproc>:
{
    80000ff4:	1101                	addi	sp,sp,-32
    80000ff6:	ec06                	sd	ra,24(sp)
    80000ff8:	e822                	sd	s0,16(sp)
    80000ffa:	e426                	sd	s1,8(sp)
    80000ffc:	1000                	addi	s0,sp,32
    80000ffe:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001000:	6d28                	ld	a0,88(a0)
    80001002:	c509                	beqz	a0,8000100c <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001004:	fffff097          	auipc	ra,0xfffff
    80001008:	018080e7          	jalr	24(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000100c:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001010:	68a8                	ld	a0,80(s1)
    80001012:	c511                	beqz	a0,8000101e <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001014:	64ac                	ld	a1,72(s1)
    80001016:	00000097          	auipc	ra,0x0
    8000101a:	f8c080e7          	jalr	-116(ra) # 80000fa2 <proc_freepagetable>
  p->pagetable = 0;
    8000101e:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001022:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001026:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000102a:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000102e:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001032:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001036:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000103a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000103e:	0004ac23          	sw	zero,24(s1)
}
    80001042:	60e2                	ld	ra,24(sp)
    80001044:	6442                	ld	s0,16(sp)
    80001046:	64a2                	ld	s1,8(sp)
    80001048:	6105                	addi	sp,sp,32
    8000104a:	8082                	ret

000000008000104c <allocproc>:
{
    8000104c:	1101                	addi	sp,sp,-32
    8000104e:	ec06                	sd	ra,24(sp)
    80001050:	e822                	sd	s0,16(sp)
    80001052:	e426                	sd	s1,8(sp)
    80001054:	e04a                	sd	s2,0(sp)
    80001056:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001058:	00008497          	auipc	s1,0x8
    8000105c:	42848493          	addi	s1,s1,1064 # 80009480 <proc>
    80001060:	0000e917          	auipc	s2,0xe
    80001064:	e2090913          	addi	s2,s2,-480 # 8000ee80 <tickslock>
    acquire(&p->lock);
    80001068:	8526                	mv	a0,s1
    8000106a:	00005097          	auipc	ra,0x5
    8000106e:	fa6080e7          	jalr	-90(ra) # 80006010 <acquire>
    if(p->state == UNUSED) {
    80001072:	4c9c                	lw	a5,24(s1)
    80001074:	cf81                	beqz	a5,8000108c <allocproc+0x40>
      release(&p->lock);
    80001076:	8526                	mv	a0,s1
    80001078:	00005097          	auipc	ra,0x5
    8000107c:	04c080e7          	jalr	76(ra) # 800060c4 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001080:	16848493          	addi	s1,s1,360
    80001084:	ff2492e3          	bne	s1,s2,80001068 <allocproc+0x1c>
  return 0;
    80001088:	4481                	li	s1,0
    8000108a:	a889                	j	800010dc <allocproc+0x90>
  p->pid = allocpid();
    8000108c:	00000097          	auipc	ra,0x0
    80001090:	e34080e7          	jalr	-460(ra) # 80000ec0 <allocpid>
    80001094:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001096:	4785                	li	a5,1
    80001098:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000109a:	fffff097          	auipc	ra,0xfffff
    8000109e:	07e080e7          	jalr	126(ra) # 80000118 <kalloc>
    800010a2:	892a                	mv	s2,a0
    800010a4:	eca8                	sd	a0,88(s1)
    800010a6:	c131                	beqz	a0,800010ea <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010a8:	8526                	mv	a0,s1
    800010aa:	00000097          	auipc	ra,0x0
    800010ae:	e5c080e7          	jalr	-420(ra) # 80000f06 <proc_pagetable>
    800010b2:	892a                	mv	s2,a0
    800010b4:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010b6:	c531                	beqz	a0,80001102 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010b8:	07000613          	li	a2,112
    800010bc:	4581                	li	a1,0
    800010be:	06048513          	addi	a0,s1,96
    800010c2:	fffff097          	auipc	ra,0xfffff
    800010c6:	0b6080e7          	jalr	182(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010ca:	00000797          	auipc	a5,0x0
    800010ce:	db078793          	addi	a5,a5,-592 # 80000e7a <forkret>
    800010d2:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010d4:	60bc                	ld	a5,64(s1)
    800010d6:	6705                	lui	a4,0x1
    800010d8:	97ba                	add	a5,a5,a4
    800010da:	f4bc                	sd	a5,104(s1)
}
    800010dc:	8526                	mv	a0,s1
    800010de:	60e2                	ld	ra,24(sp)
    800010e0:	6442                	ld	s0,16(sp)
    800010e2:	64a2                	ld	s1,8(sp)
    800010e4:	6902                	ld	s2,0(sp)
    800010e6:	6105                	addi	sp,sp,32
    800010e8:	8082                	ret
    freeproc(p);
    800010ea:	8526                	mv	a0,s1
    800010ec:	00000097          	auipc	ra,0x0
    800010f0:	f08080e7          	jalr	-248(ra) # 80000ff4 <freeproc>
    release(&p->lock);
    800010f4:	8526                	mv	a0,s1
    800010f6:	00005097          	auipc	ra,0x5
    800010fa:	fce080e7          	jalr	-50(ra) # 800060c4 <release>
    return 0;
    800010fe:	84ca                	mv	s1,s2
    80001100:	bff1                	j	800010dc <allocproc+0x90>
    freeproc(p);
    80001102:	8526                	mv	a0,s1
    80001104:	00000097          	auipc	ra,0x0
    80001108:	ef0080e7          	jalr	-272(ra) # 80000ff4 <freeproc>
    release(&p->lock);
    8000110c:	8526                	mv	a0,s1
    8000110e:	00005097          	auipc	ra,0x5
    80001112:	fb6080e7          	jalr	-74(ra) # 800060c4 <release>
    return 0;
    80001116:	84ca                	mv	s1,s2
    80001118:	b7d1                	j	800010dc <allocproc+0x90>

000000008000111a <userinit>:
{
    8000111a:	1101                	addi	sp,sp,-32
    8000111c:	ec06                	sd	ra,24(sp)
    8000111e:	e822                	sd	s0,16(sp)
    80001120:	e426                	sd	s1,8(sp)
    80001122:	1000                	addi	s0,sp,32
  p = allocproc();
    80001124:	00000097          	auipc	ra,0x0
    80001128:	f28080e7          	jalr	-216(ra) # 8000104c <allocproc>
    8000112c:	84aa                	mv	s1,a0
  initproc = p;
    8000112e:	00008797          	auipc	a5,0x8
    80001132:	eea7b123          	sd	a0,-286(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001136:	03400613          	li	a2,52
    8000113a:	00007597          	auipc	a1,0x7
    8000113e:	6e658593          	addi	a1,a1,1766 # 80008820 <initcode>
    80001142:	6928                	ld	a0,80(a0)
    80001144:	fffff097          	auipc	ra,0xfffff
    80001148:	6b4080e7          	jalr	1716(ra) # 800007f8 <uvminit>
  p->sz = PGSIZE;
    8000114c:	6785                	lui	a5,0x1
    8000114e:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001150:	6cb8                	ld	a4,88(s1)
    80001152:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001156:	6cb8                	ld	a4,88(s1)
    80001158:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000115a:	4641                	li	a2,16
    8000115c:	00007597          	auipc	a1,0x7
    80001160:	02458593          	addi	a1,a1,36 # 80008180 <etext+0x180>
    80001164:	15848513          	addi	a0,s1,344
    80001168:	fffff097          	auipc	ra,0xfffff
    8000116c:	15a080e7          	jalr	346(ra) # 800002c2 <safestrcpy>
  p->cwd = namei("/");
    80001170:	00007517          	auipc	a0,0x7
    80001174:	02050513          	addi	a0,a0,32 # 80008190 <etext+0x190>
    80001178:	00002097          	auipc	ra,0x2
    8000117c:	0a0080e7          	jalr	160(ra) # 80003218 <namei>
    80001180:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001184:	478d                	li	a5,3
    80001186:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001188:	8526                	mv	a0,s1
    8000118a:	00005097          	auipc	ra,0x5
    8000118e:	f3a080e7          	jalr	-198(ra) # 800060c4 <release>
}
    80001192:	60e2                	ld	ra,24(sp)
    80001194:	6442                	ld	s0,16(sp)
    80001196:	64a2                	ld	s1,8(sp)
    80001198:	6105                	addi	sp,sp,32
    8000119a:	8082                	ret

000000008000119c <growproc>:
{
    8000119c:	1101                	addi	sp,sp,-32
    8000119e:	ec06                	sd	ra,24(sp)
    800011a0:	e822                	sd	s0,16(sp)
    800011a2:	e426                	sd	s1,8(sp)
    800011a4:	e04a                	sd	s2,0(sp)
    800011a6:	1000                	addi	s0,sp,32
    800011a8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011aa:	00000097          	auipc	ra,0x0
    800011ae:	c98080e7          	jalr	-872(ra) # 80000e42 <myproc>
    800011b2:	892a                	mv	s2,a0
  sz = p->sz;
    800011b4:	652c                	ld	a1,72(a0)
    800011b6:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800011ba:	00904f63          	bgtz	s1,800011d8 <growproc+0x3c>
  } else if(n < 0){
    800011be:	0204cc63          	bltz	s1,800011f6 <growproc+0x5a>
  p->sz = sz;
    800011c2:	1602                	slli	a2,a2,0x20
    800011c4:	9201                	srli	a2,a2,0x20
    800011c6:	04c93423          	sd	a2,72(s2)
  return 0;
    800011ca:	4501                	li	a0,0
}
    800011cc:	60e2                	ld	ra,24(sp)
    800011ce:	6442                	ld	s0,16(sp)
    800011d0:	64a2                	ld	s1,8(sp)
    800011d2:	6902                	ld	s2,0(sp)
    800011d4:	6105                	addi	sp,sp,32
    800011d6:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800011d8:	9e25                	addw	a2,a2,s1
    800011da:	1602                	slli	a2,a2,0x20
    800011dc:	9201                	srli	a2,a2,0x20
    800011de:	1582                	slli	a1,a1,0x20
    800011e0:	9181                	srli	a1,a1,0x20
    800011e2:	6928                	ld	a0,80(a0)
    800011e4:	fffff097          	auipc	ra,0xfffff
    800011e8:	6ce080e7          	jalr	1742(ra) # 800008b2 <uvmalloc>
    800011ec:	0005061b          	sext.w	a2,a0
    800011f0:	fa69                	bnez	a2,800011c2 <growproc+0x26>
      return -1;
    800011f2:	557d                	li	a0,-1
    800011f4:	bfe1                	j	800011cc <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011f6:	9e25                	addw	a2,a2,s1
    800011f8:	1602                	slli	a2,a2,0x20
    800011fa:	9201                	srli	a2,a2,0x20
    800011fc:	1582                	slli	a1,a1,0x20
    800011fe:	9181                	srli	a1,a1,0x20
    80001200:	6928                	ld	a0,80(a0)
    80001202:	fffff097          	auipc	ra,0xfffff
    80001206:	668080e7          	jalr	1640(ra) # 8000086a <uvmdealloc>
    8000120a:	0005061b          	sext.w	a2,a0
    8000120e:	bf55                	j	800011c2 <growproc+0x26>

0000000080001210 <fork>:
{
    80001210:	7139                	addi	sp,sp,-64
    80001212:	fc06                	sd	ra,56(sp)
    80001214:	f822                	sd	s0,48(sp)
    80001216:	f426                	sd	s1,40(sp)
    80001218:	f04a                	sd	s2,32(sp)
    8000121a:	ec4e                	sd	s3,24(sp)
    8000121c:	e852                	sd	s4,16(sp)
    8000121e:	e456                	sd	s5,8(sp)
    80001220:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001222:	00000097          	auipc	ra,0x0
    80001226:	c20080e7          	jalr	-992(ra) # 80000e42 <myproc>
    8000122a:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000122c:	00000097          	auipc	ra,0x0
    80001230:	e20080e7          	jalr	-480(ra) # 8000104c <allocproc>
    80001234:	10050c63          	beqz	a0,8000134c <fork+0x13c>
    80001238:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000123a:	048ab603          	ld	a2,72(s5)
    8000123e:	692c                	ld	a1,80(a0)
    80001240:	050ab503          	ld	a0,80(s5)
    80001244:	fffff097          	auipc	ra,0xfffff
    80001248:	7ba080e7          	jalr	1978(ra) # 800009fe <uvmcopy>
    8000124c:	04054863          	bltz	a0,8000129c <fork+0x8c>
  np->sz = p->sz;
    80001250:	048ab783          	ld	a5,72(s5)
    80001254:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001258:	058ab683          	ld	a3,88(s5)
    8000125c:	87b6                	mv	a5,a3
    8000125e:	058a3703          	ld	a4,88(s4)
    80001262:	12068693          	addi	a3,a3,288
    80001266:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000126a:	6788                	ld	a0,8(a5)
    8000126c:	6b8c                	ld	a1,16(a5)
    8000126e:	6f90                	ld	a2,24(a5)
    80001270:	01073023          	sd	a6,0(a4)
    80001274:	e708                	sd	a0,8(a4)
    80001276:	eb0c                	sd	a1,16(a4)
    80001278:	ef10                	sd	a2,24(a4)
    8000127a:	02078793          	addi	a5,a5,32
    8000127e:	02070713          	addi	a4,a4,32
    80001282:	fed792e3          	bne	a5,a3,80001266 <fork+0x56>
  np->trapframe->a0 = 0;
    80001286:	058a3783          	ld	a5,88(s4)
    8000128a:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000128e:	0d0a8493          	addi	s1,s5,208
    80001292:	0d0a0913          	addi	s2,s4,208
    80001296:	150a8993          	addi	s3,s5,336
    8000129a:	a00d                	j	800012bc <fork+0xac>
    freeproc(np);
    8000129c:	8552                	mv	a0,s4
    8000129e:	00000097          	auipc	ra,0x0
    800012a2:	d56080e7          	jalr	-682(ra) # 80000ff4 <freeproc>
    release(&np->lock);
    800012a6:	8552                	mv	a0,s4
    800012a8:	00005097          	auipc	ra,0x5
    800012ac:	e1c080e7          	jalr	-484(ra) # 800060c4 <release>
    return -1;
    800012b0:	597d                	li	s2,-1
    800012b2:	a059                	j	80001338 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    800012b4:	04a1                	addi	s1,s1,8
    800012b6:	0921                	addi	s2,s2,8
    800012b8:	01348b63          	beq	s1,s3,800012ce <fork+0xbe>
    if(p->ofile[i])
    800012bc:	6088                	ld	a0,0(s1)
    800012be:	d97d                	beqz	a0,800012b4 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    800012c0:	00002097          	auipc	ra,0x2
    800012c4:	5ee080e7          	jalr	1518(ra) # 800038ae <filedup>
    800012c8:	00a93023          	sd	a0,0(s2)
    800012cc:	b7e5                	j	800012b4 <fork+0xa4>
  np->cwd = idup(p->cwd);
    800012ce:	150ab503          	ld	a0,336(s5)
    800012d2:	00001097          	auipc	ra,0x1
    800012d6:	752080e7          	jalr	1874(ra) # 80002a24 <idup>
    800012da:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012de:	4641                	li	a2,16
    800012e0:	158a8593          	addi	a1,s5,344
    800012e4:	158a0513          	addi	a0,s4,344
    800012e8:	fffff097          	auipc	ra,0xfffff
    800012ec:	fda080e7          	jalr	-38(ra) # 800002c2 <safestrcpy>
  pid = np->pid;
    800012f0:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800012f4:	8552                	mv	a0,s4
    800012f6:	00005097          	auipc	ra,0x5
    800012fa:	dce080e7          	jalr	-562(ra) # 800060c4 <release>
  acquire(&wait_lock);
    800012fe:	00008497          	auipc	s1,0x8
    80001302:	d6a48493          	addi	s1,s1,-662 # 80009068 <wait_lock>
    80001306:	8526                	mv	a0,s1
    80001308:	00005097          	auipc	ra,0x5
    8000130c:	d08080e7          	jalr	-760(ra) # 80006010 <acquire>
  np->parent = p;
    80001310:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001314:	8526                	mv	a0,s1
    80001316:	00005097          	auipc	ra,0x5
    8000131a:	dae080e7          	jalr	-594(ra) # 800060c4 <release>
  acquire(&np->lock);
    8000131e:	8552                	mv	a0,s4
    80001320:	00005097          	auipc	ra,0x5
    80001324:	cf0080e7          	jalr	-784(ra) # 80006010 <acquire>
  np->state = RUNNABLE;
    80001328:	478d                	li	a5,3
    8000132a:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000132e:	8552                	mv	a0,s4
    80001330:	00005097          	auipc	ra,0x5
    80001334:	d94080e7          	jalr	-620(ra) # 800060c4 <release>
}
    80001338:	854a                	mv	a0,s2
    8000133a:	70e2                	ld	ra,56(sp)
    8000133c:	7442                	ld	s0,48(sp)
    8000133e:	74a2                	ld	s1,40(sp)
    80001340:	7902                	ld	s2,32(sp)
    80001342:	69e2                	ld	s3,24(sp)
    80001344:	6a42                	ld	s4,16(sp)
    80001346:	6aa2                	ld	s5,8(sp)
    80001348:	6121                	addi	sp,sp,64
    8000134a:	8082                	ret
    return -1;
    8000134c:	597d                	li	s2,-1
    8000134e:	b7ed                	j	80001338 <fork+0x128>

0000000080001350 <scheduler>:
{
    80001350:	7139                	addi	sp,sp,-64
    80001352:	fc06                	sd	ra,56(sp)
    80001354:	f822                	sd	s0,48(sp)
    80001356:	f426                	sd	s1,40(sp)
    80001358:	f04a                	sd	s2,32(sp)
    8000135a:	ec4e                	sd	s3,24(sp)
    8000135c:	e852                	sd	s4,16(sp)
    8000135e:	e456                	sd	s5,8(sp)
    80001360:	e05a                	sd	s6,0(sp)
    80001362:	0080                	addi	s0,sp,64
    80001364:	8792                	mv	a5,tp
  int id = r_tp();
    80001366:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001368:	00779a93          	slli	s5,a5,0x7
    8000136c:	00008717          	auipc	a4,0x8
    80001370:	ce470713          	addi	a4,a4,-796 # 80009050 <pid_lock>
    80001374:	9756                	add	a4,a4,s5
    80001376:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000137a:	00008717          	auipc	a4,0x8
    8000137e:	d0e70713          	addi	a4,a4,-754 # 80009088 <cpus+0x8>
    80001382:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001384:	498d                	li	s3,3
        p->state = RUNNING;
    80001386:	4b11                	li	s6,4
        c->proc = p;
    80001388:	079e                	slli	a5,a5,0x7
    8000138a:	00008a17          	auipc	s4,0x8
    8000138e:	cc6a0a13          	addi	s4,s4,-826 # 80009050 <pid_lock>
    80001392:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001394:	0000e917          	auipc	s2,0xe
    80001398:	aec90913          	addi	s2,s2,-1300 # 8000ee80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000139c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013a0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013a4:	10079073          	csrw	sstatus,a5
    800013a8:	00008497          	auipc	s1,0x8
    800013ac:	0d848493          	addi	s1,s1,216 # 80009480 <proc>
    800013b0:	a811                	j	800013c4 <scheduler+0x74>
      release(&p->lock);
    800013b2:	8526                	mv	a0,s1
    800013b4:	00005097          	auipc	ra,0x5
    800013b8:	d10080e7          	jalr	-752(ra) # 800060c4 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013bc:	16848493          	addi	s1,s1,360
    800013c0:	fd248ee3          	beq	s1,s2,8000139c <scheduler+0x4c>
      acquire(&p->lock);
    800013c4:	8526                	mv	a0,s1
    800013c6:	00005097          	auipc	ra,0x5
    800013ca:	c4a080e7          	jalr	-950(ra) # 80006010 <acquire>
      if(p->state == RUNNABLE) {
    800013ce:	4c9c                	lw	a5,24(s1)
    800013d0:	ff3791e3          	bne	a5,s3,800013b2 <scheduler+0x62>
        p->state = RUNNING;
    800013d4:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013d8:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013dc:	06048593          	addi	a1,s1,96
    800013e0:	8556                	mv	a0,s5
    800013e2:	00000097          	auipc	ra,0x0
    800013e6:	61e080e7          	jalr	1566(ra) # 80001a00 <swtch>
        c->proc = 0;
    800013ea:	020a3823          	sd	zero,48(s4)
    800013ee:	b7d1                	j	800013b2 <scheduler+0x62>

00000000800013f0 <sched>:
{
    800013f0:	7179                	addi	sp,sp,-48
    800013f2:	f406                	sd	ra,40(sp)
    800013f4:	f022                	sd	s0,32(sp)
    800013f6:	ec26                	sd	s1,24(sp)
    800013f8:	e84a                	sd	s2,16(sp)
    800013fa:	e44e                	sd	s3,8(sp)
    800013fc:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013fe:	00000097          	auipc	ra,0x0
    80001402:	a44080e7          	jalr	-1468(ra) # 80000e42 <myproc>
    80001406:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001408:	00005097          	auipc	ra,0x5
    8000140c:	b8e080e7          	jalr	-1138(ra) # 80005f96 <holding>
    80001410:	c93d                	beqz	a0,80001486 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001412:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001414:	2781                	sext.w	a5,a5
    80001416:	079e                	slli	a5,a5,0x7
    80001418:	00008717          	auipc	a4,0x8
    8000141c:	c3870713          	addi	a4,a4,-968 # 80009050 <pid_lock>
    80001420:	97ba                	add	a5,a5,a4
    80001422:	0a87a703          	lw	a4,168(a5)
    80001426:	4785                	li	a5,1
    80001428:	06f71763          	bne	a4,a5,80001496 <sched+0xa6>
  if(p->state == RUNNING)
    8000142c:	4c98                	lw	a4,24(s1)
    8000142e:	4791                	li	a5,4
    80001430:	06f70b63          	beq	a4,a5,800014a6 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001434:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001438:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000143a:	efb5                	bnez	a5,800014b6 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000143c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000143e:	00008917          	auipc	s2,0x8
    80001442:	c1290913          	addi	s2,s2,-1006 # 80009050 <pid_lock>
    80001446:	2781                	sext.w	a5,a5
    80001448:	079e                	slli	a5,a5,0x7
    8000144a:	97ca                	add	a5,a5,s2
    8000144c:	0ac7a983          	lw	s3,172(a5)
    80001450:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001452:	2781                	sext.w	a5,a5
    80001454:	079e                	slli	a5,a5,0x7
    80001456:	00008597          	auipc	a1,0x8
    8000145a:	c3258593          	addi	a1,a1,-974 # 80009088 <cpus+0x8>
    8000145e:	95be                	add	a1,a1,a5
    80001460:	06048513          	addi	a0,s1,96
    80001464:	00000097          	auipc	ra,0x0
    80001468:	59c080e7          	jalr	1436(ra) # 80001a00 <swtch>
    8000146c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000146e:	2781                	sext.w	a5,a5
    80001470:	079e                	slli	a5,a5,0x7
    80001472:	97ca                	add	a5,a5,s2
    80001474:	0b37a623          	sw	s3,172(a5)
}
    80001478:	70a2                	ld	ra,40(sp)
    8000147a:	7402                	ld	s0,32(sp)
    8000147c:	64e2                	ld	s1,24(sp)
    8000147e:	6942                	ld	s2,16(sp)
    80001480:	69a2                	ld	s3,8(sp)
    80001482:	6145                	addi	sp,sp,48
    80001484:	8082                	ret
    panic("sched p->lock");
    80001486:	00007517          	auipc	a0,0x7
    8000148a:	d1250513          	addi	a0,a0,-750 # 80008198 <etext+0x198>
    8000148e:	00004097          	auipc	ra,0x4
    80001492:	646080e7          	jalr	1606(ra) # 80005ad4 <panic>
    panic("sched locks");
    80001496:	00007517          	auipc	a0,0x7
    8000149a:	d1250513          	addi	a0,a0,-750 # 800081a8 <etext+0x1a8>
    8000149e:	00004097          	auipc	ra,0x4
    800014a2:	636080e7          	jalr	1590(ra) # 80005ad4 <panic>
    panic("sched running");
    800014a6:	00007517          	auipc	a0,0x7
    800014aa:	d1250513          	addi	a0,a0,-750 # 800081b8 <etext+0x1b8>
    800014ae:	00004097          	auipc	ra,0x4
    800014b2:	626080e7          	jalr	1574(ra) # 80005ad4 <panic>
    panic("sched interruptible");
    800014b6:	00007517          	auipc	a0,0x7
    800014ba:	d1250513          	addi	a0,a0,-750 # 800081c8 <etext+0x1c8>
    800014be:	00004097          	auipc	ra,0x4
    800014c2:	616080e7          	jalr	1558(ra) # 80005ad4 <panic>

00000000800014c6 <yield>:
{
    800014c6:	1101                	addi	sp,sp,-32
    800014c8:	ec06                	sd	ra,24(sp)
    800014ca:	e822                	sd	s0,16(sp)
    800014cc:	e426                	sd	s1,8(sp)
    800014ce:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014d0:	00000097          	auipc	ra,0x0
    800014d4:	972080e7          	jalr	-1678(ra) # 80000e42 <myproc>
    800014d8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014da:	00005097          	auipc	ra,0x5
    800014de:	b36080e7          	jalr	-1226(ra) # 80006010 <acquire>
  p->state = RUNNABLE;
    800014e2:	478d                	li	a5,3
    800014e4:	cc9c                	sw	a5,24(s1)
  sched();
    800014e6:	00000097          	auipc	ra,0x0
    800014ea:	f0a080e7          	jalr	-246(ra) # 800013f0 <sched>
  release(&p->lock);
    800014ee:	8526                	mv	a0,s1
    800014f0:	00005097          	auipc	ra,0x5
    800014f4:	bd4080e7          	jalr	-1068(ra) # 800060c4 <release>
}
    800014f8:	60e2                	ld	ra,24(sp)
    800014fa:	6442                	ld	s0,16(sp)
    800014fc:	64a2                	ld	s1,8(sp)
    800014fe:	6105                	addi	sp,sp,32
    80001500:	8082                	ret

0000000080001502 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001502:	7179                	addi	sp,sp,-48
    80001504:	f406                	sd	ra,40(sp)
    80001506:	f022                	sd	s0,32(sp)
    80001508:	ec26                	sd	s1,24(sp)
    8000150a:	e84a                	sd	s2,16(sp)
    8000150c:	e44e                	sd	s3,8(sp)
    8000150e:	1800                	addi	s0,sp,48
    80001510:	89aa                	mv	s3,a0
    80001512:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001514:	00000097          	auipc	ra,0x0
    80001518:	92e080e7          	jalr	-1746(ra) # 80000e42 <myproc>
    8000151c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000151e:	00005097          	auipc	ra,0x5
    80001522:	af2080e7          	jalr	-1294(ra) # 80006010 <acquire>
  release(lk);
    80001526:	854a                	mv	a0,s2
    80001528:	00005097          	auipc	ra,0x5
    8000152c:	b9c080e7          	jalr	-1124(ra) # 800060c4 <release>

  // Go to sleep.
  p->chan = chan;
    80001530:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001534:	4789                	li	a5,2
    80001536:	cc9c                	sw	a5,24(s1)

  sched();
    80001538:	00000097          	auipc	ra,0x0
    8000153c:	eb8080e7          	jalr	-328(ra) # 800013f0 <sched>

  // Tidy up.
  p->chan = 0;
    80001540:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001544:	8526                	mv	a0,s1
    80001546:	00005097          	auipc	ra,0x5
    8000154a:	b7e080e7          	jalr	-1154(ra) # 800060c4 <release>
  acquire(lk);
    8000154e:	854a                	mv	a0,s2
    80001550:	00005097          	auipc	ra,0x5
    80001554:	ac0080e7          	jalr	-1344(ra) # 80006010 <acquire>
}
    80001558:	70a2                	ld	ra,40(sp)
    8000155a:	7402                	ld	s0,32(sp)
    8000155c:	64e2                	ld	s1,24(sp)
    8000155e:	6942                	ld	s2,16(sp)
    80001560:	69a2                	ld	s3,8(sp)
    80001562:	6145                	addi	sp,sp,48
    80001564:	8082                	ret

0000000080001566 <wait>:
{
    80001566:	715d                	addi	sp,sp,-80
    80001568:	e486                	sd	ra,72(sp)
    8000156a:	e0a2                	sd	s0,64(sp)
    8000156c:	fc26                	sd	s1,56(sp)
    8000156e:	f84a                	sd	s2,48(sp)
    80001570:	f44e                	sd	s3,40(sp)
    80001572:	f052                	sd	s4,32(sp)
    80001574:	ec56                	sd	s5,24(sp)
    80001576:	e85a                	sd	s6,16(sp)
    80001578:	e45e                	sd	s7,8(sp)
    8000157a:	e062                	sd	s8,0(sp)
    8000157c:	0880                	addi	s0,sp,80
    8000157e:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001580:	00000097          	auipc	ra,0x0
    80001584:	8c2080e7          	jalr	-1854(ra) # 80000e42 <myproc>
    80001588:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000158a:	00008517          	auipc	a0,0x8
    8000158e:	ade50513          	addi	a0,a0,-1314 # 80009068 <wait_lock>
    80001592:	00005097          	auipc	ra,0x5
    80001596:	a7e080e7          	jalr	-1410(ra) # 80006010 <acquire>
    havekids = 0;
    8000159a:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000159c:	4a15                	li	s4,5
        havekids = 1;
    8000159e:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800015a0:	0000e997          	auipc	s3,0xe
    800015a4:	8e098993          	addi	s3,s3,-1824 # 8000ee80 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015a8:	00008c17          	auipc	s8,0x8
    800015ac:	ac0c0c13          	addi	s8,s8,-1344 # 80009068 <wait_lock>
    havekids = 0;
    800015b0:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800015b2:	00008497          	auipc	s1,0x8
    800015b6:	ece48493          	addi	s1,s1,-306 # 80009480 <proc>
    800015ba:	a0bd                	j	80001628 <wait+0xc2>
          pid = np->pid;
    800015bc:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015c0:	000b0e63          	beqz	s6,800015dc <wait+0x76>
    800015c4:	4691                	li	a3,4
    800015c6:	02c48613          	addi	a2,s1,44
    800015ca:	85da                	mv	a1,s6
    800015cc:	05093503          	ld	a0,80(s2)
    800015d0:	fffff097          	auipc	ra,0xfffff
    800015d4:	532080e7          	jalr	1330(ra) # 80000b02 <copyout>
    800015d8:	02054563          	bltz	a0,80001602 <wait+0x9c>
          freeproc(np);
    800015dc:	8526                	mv	a0,s1
    800015de:	00000097          	auipc	ra,0x0
    800015e2:	a16080e7          	jalr	-1514(ra) # 80000ff4 <freeproc>
          release(&np->lock);
    800015e6:	8526                	mv	a0,s1
    800015e8:	00005097          	auipc	ra,0x5
    800015ec:	adc080e7          	jalr	-1316(ra) # 800060c4 <release>
          release(&wait_lock);
    800015f0:	00008517          	auipc	a0,0x8
    800015f4:	a7850513          	addi	a0,a0,-1416 # 80009068 <wait_lock>
    800015f8:	00005097          	auipc	ra,0x5
    800015fc:	acc080e7          	jalr	-1332(ra) # 800060c4 <release>
          return pid;
    80001600:	a09d                	j	80001666 <wait+0x100>
            release(&np->lock);
    80001602:	8526                	mv	a0,s1
    80001604:	00005097          	auipc	ra,0x5
    80001608:	ac0080e7          	jalr	-1344(ra) # 800060c4 <release>
            release(&wait_lock);
    8000160c:	00008517          	auipc	a0,0x8
    80001610:	a5c50513          	addi	a0,a0,-1444 # 80009068 <wait_lock>
    80001614:	00005097          	auipc	ra,0x5
    80001618:	ab0080e7          	jalr	-1360(ra) # 800060c4 <release>
            return -1;
    8000161c:	59fd                	li	s3,-1
    8000161e:	a0a1                	j	80001666 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001620:	16848493          	addi	s1,s1,360
    80001624:	03348463          	beq	s1,s3,8000164c <wait+0xe6>
      if(np->parent == p){
    80001628:	7c9c                	ld	a5,56(s1)
    8000162a:	ff279be3          	bne	a5,s2,80001620 <wait+0xba>
        acquire(&np->lock);
    8000162e:	8526                	mv	a0,s1
    80001630:	00005097          	auipc	ra,0x5
    80001634:	9e0080e7          	jalr	-1568(ra) # 80006010 <acquire>
        if(np->state == ZOMBIE){
    80001638:	4c9c                	lw	a5,24(s1)
    8000163a:	f94781e3          	beq	a5,s4,800015bc <wait+0x56>
        release(&np->lock);
    8000163e:	8526                	mv	a0,s1
    80001640:	00005097          	auipc	ra,0x5
    80001644:	a84080e7          	jalr	-1404(ra) # 800060c4 <release>
        havekids = 1;
    80001648:	8756                	mv	a4,s5
    8000164a:	bfd9                	j	80001620 <wait+0xba>
    if(!havekids || p->killed){
    8000164c:	c701                	beqz	a4,80001654 <wait+0xee>
    8000164e:	02892783          	lw	a5,40(s2)
    80001652:	c79d                	beqz	a5,80001680 <wait+0x11a>
      release(&wait_lock);
    80001654:	00008517          	auipc	a0,0x8
    80001658:	a1450513          	addi	a0,a0,-1516 # 80009068 <wait_lock>
    8000165c:	00005097          	auipc	ra,0x5
    80001660:	a68080e7          	jalr	-1432(ra) # 800060c4 <release>
      return -1;
    80001664:	59fd                	li	s3,-1
}
    80001666:	854e                	mv	a0,s3
    80001668:	60a6                	ld	ra,72(sp)
    8000166a:	6406                	ld	s0,64(sp)
    8000166c:	74e2                	ld	s1,56(sp)
    8000166e:	7942                	ld	s2,48(sp)
    80001670:	79a2                	ld	s3,40(sp)
    80001672:	7a02                	ld	s4,32(sp)
    80001674:	6ae2                	ld	s5,24(sp)
    80001676:	6b42                	ld	s6,16(sp)
    80001678:	6ba2                	ld	s7,8(sp)
    8000167a:	6c02                	ld	s8,0(sp)
    8000167c:	6161                	addi	sp,sp,80
    8000167e:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001680:	85e2                	mv	a1,s8
    80001682:	854a                	mv	a0,s2
    80001684:	00000097          	auipc	ra,0x0
    80001688:	e7e080e7          	jalr	-386(ra) # 80001502 <sleep>
    havekids = 0;
    8000168c:	b715                	j	800015b0 <wait+0x4a>

000000008000168e <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000168e:	7139                	addi	sp,sp,-64
    80001690:	fc06                	sd	ra,56(sp)
    80001692:	f822                	sd	s0,48(sp)
    80001694:	f426                	sd	s1,40(sp)
    80001696:	f04a                	sd	s2,32(sp)
    80001698:	ec4e                	sd	s3,24(sp)
    8000169a:	e852                	sd	s4,16(sp)
    8000169c:	e456                	sd	s5,8(sp)
    8000169e:	0080                	addi	s0,sp,64
    800016a0:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016a2:	00008497          	auipc	s1,0x8
    800016a6:	dde48493          	addi	s1,s1,-546 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016aa:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016ac:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016ae:	0000d917          	auipc	s2,0xd
    800016b2:	7d290913          	addi	s2,s2,2002 # 8000ee80 <tickslock>
    800016b6:	a811                	j	800016ca <wakeup+0x3c>
      }
      release(&p->lock);
    800016b8:	8526                	mv	a0,s1
    800016ba:	00005097          	auipc	ra,0x5
    800016be:	a0a080e7          	jalr	-1526(ra) # 800060c4 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016c2:	16848493          	addi	s1,s1,360
    800016c6:	03248663          	beq	s1,s2,800016f2 <wakeup+0x64>
    if(p != myproc()){
    800016ca:	fffff097          	auipc	ra,0xfffff
    800016ce:	778080e7          	jalr	1912(ra) # 80000e42 <myproc>
    800016d2:	fea488e3          	beq	s1,a0,800016c2 <wakeup+0x34>
      acquire(&p->lock);
    800016d6:	8526                	mv	a0,s1
    800016d8:	00005097          	auipc	ra,0x5
    800016dc:	938080e7          	jalr	-1736(ra) # 80006010 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800016e0:	4c9c                	lw	a5,24(s1)
    800016e2:	fd379be3          	bne	a5,s3,800016b8 <wakeup+0x2a>
    800016e6:	709c                	ld	a5,32(s1)
    800016e8:	fd4798e3          	bne	a5,s4,800016b8 <wakeup+0x2a>
        p->state = RUNNABLE;
    800016ec:	0154ac23          	sw	s5,24(s1)
    800016f0:	b7e1                	j	800016b8 <wakeup+0x2a>
    }
  }
}
    800016f2:	70e2                	ld	ra,56(sp)
    800016f4:	7442                	ld	s0,48(sp)
    800016f6:	74a2                	ld	s1,40(sp)
    800016f8:	7902                	ld	s2,32(sp)
    800016fa:	69e2                	ld	s3,24(sp)
    800016fc:	6a42                	ld	s4,16(sp)
    800016fe:	6aa2                	ld	s5,8(sp)
    80001700:	6121                	addi	sp,sp,64
    80001702:	8082                	ret

0000000080001704 <reparent>:
{
    80001704:	7179                	addi	sp,sp,-48
    80001706:	f406                	sd	ra,40(sp)
    80001708:	f022                	sd	s0,32(sp)
    8000170a:	ec26                	sd	s1,24(sp)
    8000170c:	e84a                	sd	s2,16(sp)
    8000170e:	e44e                	sd	s3,8(sp)
    80001710:	e052                	sd	s4,0(sp)
    80001712:	1800                	addi	s0,sp,48
    80001714:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001716:	00008497          	auipc	s1,0x8
    8000171a:	d6a48493          	addi	s1,s1,-662 # 80009480 <proc>
      pp->parent = initproc;
    8000171e:	00008a17          	auipc	s4,0x8
    80001722:	8f2a0a13          	addi	s4,s4,-1806 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001726:	0000d997          	auipc	s3,0xd
    8000172a:	75a98993          	addi	s3,s3,1882 # 8000ee80 <tickslock>
    8000172e:	a029                	j	80001738 <reparent+0x34>
    80001730:	16848493          	addi	s1,s1,360
    80001734:	01348d63          	beq	s1,s3,8000174e <reparent+0x4a>
    if(pp->parent == p){
    80001738:	7c9c                	ld	a5,56(s1)
    8000173a:	ff279be3          	bne	a5,s2,80001730 <reparent+0x2c>
      pp->parent = initproc;
    8000173e:	000a3503          	ld	a0,0(s4)
    80001742:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001744:	00000097          	auipc	ra,0x0
    80001748:	f4a080e7          	jalr	-182(ra) # 8000168e <wakeup>
    8000174c:	b7d5                	j	80001730 <reparent+0x2c>
}
    8000174e:	70a2                	ld	ra,40(sp)
    80001750:	7402                	ld	s0,32(sp)
    80001752:	64e2                	ld	s1,24(sp)
    80001754:	6942                	ld	s2,16(sp)
    80001756:	69a2                	ld	s3,8(sp)
    80001758:	6a02                	ld	s4,0(sp)
    8000175a:	6145                	addi	sp,sp,48
    8000175c:	8082                	ret

000000008000175e <exit>:
{
    8000175e:	7179                	addi	sp,sp,-48
    80001760:	f406                	sd	ra,40(sp)
    80001762:	f022                	sd	s0,32(sp)
    80001764:	ec26                	sd	s1,24(sp)
    80001766:	e84a                	sd	s2,16(sp)
    80001768:	e44e                	sd	s3,8(sp)
    8000176a:	e052                	sd	s4,0(sp)
    8000176c:	1800                	addi	s0,sp,48
    8000176e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001770:	fffff097          	auipc	ra,0xfffff
    80001774:	6d2080e7          	jalr	1746(ra) # 80000e42 <myproc>
    80001778:	89aa                	mv	s3,a0
  if(p == initproc)
    8000177a:	00008797          	auipc	a5,0x8
    8000177e:	8967b783          	ld	a5,-1898(a5) # 80009010 <initproc>
    80001782:	0d050493          	addi	s1,a0,208
    80001786:	15050913          	addi	s2,a0,336
    8000178a:	02a79363          	bne	a5,a0,800017b0 <exit+0x52>
    panic("init exiting");
    8000178e:	00007517          	auipc	a0,0x7
    80001792:	a5250513          	addi	a0,a0,-1454 # 800081e0 <etext+0x1e0>
    80001796:	00004097          	auipc	ra,0x4
    8000179a:	33e080e7          	jalr	830(ra) # 80005ad4 <panic>
      fileclose(f);
    8000179e:	00002097          	auipc	ra,0x2
    800017a2:	162080e7          	jalr	354(ra) # 80003900 <fileclose>
      p->ofile[fd] = 0;
    800017a6:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017aa:	04a1                	addi	s1,s1,8
    800017ac:	01248563          	beq	s1,s2,800017b6 <exit+0x58>
    if(p->ofile[fd]){
    800017b0:	6088                	ld	a0,0(s1)
    800017b2:	f575                	bnez	a0,8000179e <exit+0x40>
    800017b4:	bfdd                	j	800017aa <exit+0x4c>
  begin_op();
    800017b6:	00002097          	auipc	ra,0x2
    800017ba:	c7e080e7          	jalr	-898(ra) # 80003434 <begin_op>
  iput(p->cwd);
    800017be:	1509b503          	ld	a0,336(s3)
    800017c2:	00001097          	auipc	ra,0x1
    800017c6:	45a080e7          	jalr	1114(ra) # 80002c1c <iput>
  end_op();
    800017ca:	00002097          	auipc	ra,0x2
    800017ce:	cea080e7          	jalr	-790(ra) # 800034b4 <end_op>
  p->cwd = 0;
    800017d2:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800017d6:	00008497          	auipc	s1,0x8
    800017da:	89248493          	addi	s1,s1,-1902 # 80009068 <wait_lock>
    800017de:	8526                	mv	a0,s1
    800017e0:	00005097          	auipc	ra,0x5
    800017e4:	830080e7          	jalr	-2000(ra) # 80006010 <acquire>
  reparent(p);
    800017e8:	854e                	mv	a0,s3
    800017ea:	00000097          	auipc	ra,0x0
    800017ee:	f1a080e7          	jalr	-230(ra) # 80001704 <reparent>
  wakeup(p->parent);
    800017f2:	0389b503          	ld	a0,56(s3)
    800017f6:	00000097          	auipc	ra,0x0
    800017fa:	e98080e7          	jalr	-360(ra) # 8000168e <wakeup>
  acquire(&p->lock);
    800017fe:	854e                	mv	a0,s3
    80001800:	00005097          	auipc	ra,0x5
    80001804:	810080e7          	jalr	-2032(ra) # 80006010 <acquire>
  p->xstate = status;
    80001808:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000180c:	4795                	li	a5,5
    8000180e:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001812:	8526                	mv	a0,s1
    80001814:	00005097          	auipc	ra,0x5
    80001818:	8b0080e7          	jalr	-1872(ra) # 800060c4 <release>
  sched();
    8000181c:	00000097          	auipc	ra,0x0
    80001820:	bd4080e7          	jalr	-1068(ra) # 800013f0 <sched>
  panic("zombie exit");
    80001824:	00007517          	auipc	a0,0x7
    80001828:	9cc50513          	addi	a0,a0,-1588 # 800081f0 <etext+0x1f0>
    8000182c:	00004097          	auipc	ra,0x4
    80001830:	2a8080e7          	jalr	680(ra) # 80005ad4 <panic>

0000000080001834 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001834:	7179                	addi	sp,sp,-48
    80001836:	f406                	sd	ra,40(sp)
    80001838:	f022                	sd	s0,32(sp)
    8000183a:	ec26                	sd	s1,24(sp)
    8000183c:	e84a                	sd	s2,16(sp)
    8000183e:	e44e                	sd	s3,8(sp)
    80001840:	1800                	addi	s0,sp,48
    80001842:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001844:	00008497          	auipc	s1,0x8
    80001848:	c3c48493          	addi	s1,s1,-964 # 80009480 <proc>
    8000184c:	0000d997          	auipc	s3,0xd
    80001850:	63498993          	addi	s3,s3,1588 # 8000ee80 <tickslock>
    acquire(&p->lock);
    80001854:	8526                	mv	a0,s1
    80001856:	00004097          	auipc	ra,0x4
    8000185a:	7ba080e7          	jalr	1978(ra) # 80006010 <acquire>
    if(p->pid == pid){
    8000185e:	589c                	lw	a5,48(s1)
    80001860:	01278d63          	beq	a5,s2,8000187a <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001864:	8526                	mv	a0,s1
    80001866:	00005097          	auipc	ra,0x5
    8000186a:	85e080e7          	jalr	-1954(ra) # 800060c4 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000186e:	16848493          	addi	s1,s1,360
    80001872:	ff3491e3          	bne	s1,s3,80001854 <kill+0x20>
  }
  return -1;
    80001876:	557d                	li	a0,-1
    80001878:	a829                	j	80001892 <kill+0x5e>
      p->killed = 1;
    8000187a:	4785                	li	a5,1
    8000187c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000187e:	4c98                	lw	a4,24(s1)
    80001880:	4789                	li	a5,2
    80001882:	00f70f63          	beq	a4,a5,800018a0 <kill+0x6c>
      release(&p->lock);
    80001886:	8526                	mv	a0,s1
    80001888:	00005097          	auipc	ra,0x5
    8000188c:	83c080e7          	jalr	-1988(ra) # 800060c4 <release>
      return 0;
    80001890:	4501                	li	a0,0
}
    80001892:	70a2                	ld	ra,40(sp)
    80001894:	7402                	ld	s0,32(sp)
    80001896:	64e2                	ld	s1,24(sp)
    80001898:	6942                	ld	s2,16(sp)
    8000189a:	69a2                	ld	s3,8(sp)
    8000189c:	6145                	addi	sp,sp,48
    8000189e:	8082                	ret
        p->state = RUNNABLE;
    800018a0:	478d                	li	a5,3
    800018a2:	cc9c                	sw	a5,24(s1)
    800018a4:	b7cd                	j	80001886 <kill+0x52>

00000000800018a6 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018a6:	7179                	addi	sp,sp,-48
    800018a8:	f406                	sd	ra,40(sp)
    800018aa:	f022                	sd	s0,32(sp)
    800018ac:	ec26                	sd	s1,24(sp)
    800018ae:	e84a                	sd	s2,16(sp)
    800018b0:	e44e                	sd	s3,8(sp)
    800018b2:	e052                	sd	s4,0(sp)
    800018b4:	1800                	addi	s0,sp,48
    800018b6:	84aa                	mv	s1,a0
    800018b8:	892e                	mv	s2,a1
    800018ba:	89b2                	mv	s3,a2
    800018bc:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018be:	fffff097          	auipc	ra,0xfffff
    800018c2:	584080e7          	jalr	1412(ra) # 80000e42 <myproc>
  if(user_dst){
    800018c6:	c08d                	beqz	s1,800018e8 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800018c8:	86d2                	mv	a3,s4
    800018ca:	864e                	mv	a2,s3
    800018cc:	85ca                	mv	a1,s2
    800018ce:	6928                	ld	a0,80(a0)
    800018d0:	fffff097          	auipc	ra,0xfffff
    800018d4:	232080e7          	jalr	562(ra) # 80000b02 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800018d8:	70a2                	ld	ra,40(sp)
    800018da:	7402                	ld	s0,32(sp)
    800018dc:	64e2                	ld	s1,24(sp)
    800018de:	6942                	ld	s2,16(sp)
    800018e0:	69a2                	ld	s3,8(sp)
    800018e2:	6a02                	ld	s4,0(sp)
    800018e4:	6145                	addi	sp,sp,48
    800018e6:	8082                	ret
    memmove((char *)dst, src, len);
    800018e8:	000a061b          	sext.w	a2,s4
    800018ec:	85ce                	mv	a1,s3
    800018ee:	854a                	mv	a0,s2
    800018f0:	fffff097          	auipc	ra,0xfffff
    800018f4:	8e4080e7          	jalr	-1820(ra) # 800001d4 <memmove>
    return 0;
    800018f8:	8526                	mv	a0,s1
    800018fa:	bff9                	j	800018d8 <either_copyout+0x32>

00000000800018fc <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800018fc:	7179                	addi	sp,sp,-48
    800018fe:	f406                	sd	ra,40(sp)
    80001900:	f022                	sd	s0,32(sp)
    80001902:	ec26                	sd	s1,24(sp)
    80001904:	e84a                	sd	s2,16(sp)
    80001906:	e44e                	sd	s3,8(sp)
    80001908:	e052                	sd	s4,0(sp)
    8000190a:	1800                	addi	s0,sp,48
    8000190c:	892a                	mv	s2,a0
    8000190e:	84ae                	mv	s1,a1
    80001910:	89b2                	mv	s3,a2
    80001912:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001914:	fffff097          	auipc	ra,0xfffff
    80001918:	52e080e7          	jalr	1326(ra) # 80000e42 <myproc>
  if(user_src){
    8000191c:	c08d                	beqz	s1,8000193e <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000191e:	86d2                	mv	a3,s4
    80001920:	864e                	mv	a2,s3
    80001922:	85ca                	mv	a1,s2
    80001924:	6928                	ld	a0,80(a0)
    80001926:	fffff097          	auipc	ra,0xfffff
    8000192a:	268080e7          	jalr	616(ra) # 80000b8e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000192e:	70a2                	ld	ra,40(sp)
    80001930:	7402                	ld	s0,32(sp)
    80001932:	64e2                	ld	s1,24(sp)
    80001934:	6942                	ld	s2,16(sp)
    80001936:	69a2                	ld	s3,8(sp)
    80001938:	6a02                	ld	s4,0(sp)
    8000193a:	6145                	addi	sp,sp,48
    8000193c:	8082                	ret
    memmove(dst, (char*)src, len);
    8000193e:	000a061b          	sext.w	a2,s4
    80001942:	85ce                	mv	a1,s3
    80001944:	854a                	mv	a0,s2
    80001946:	fffff097          	auipc	ra,0xfffff
    8000194a:	88e080e7          	jalr	-1906(ra) # 800001d4 <memmove>
    return 0;
    8000194e:	8526                	mv	a0,s1
    80001950:	bff9                	j	8000192e <either_copyin+0x32>

0000000080001952 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001952:	715d                	addi	sp,sp,-80
    80001954:	e486                	sd	ra,72(sp)
    80001956:	e0a2                	sd	s0,64(sp)
    80001958:	fc26                	sd	s1,56(sp)
    8000195a:	f84a                	sd	s2,48(sp)
    8000195c:	f44e                	sd	s3,40(sp)
    8000195e:	f052                	sd	s4,32(sp)
    80001960:	ec56                	sd	s5,24(sp)
    80001962:	e85a                	sd	s6,16(sp)
    80001964:	e45e                	sd	s7,8(sp)
    80001966:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001968:	00006517          	auipc	a0,0x6
    8000196c:	6e050513          	addi	a0,a0,1760 # 80008048 <etext+0x48>
    80001970:	00004097          	auipc	ra,0x4
    80001974:	1ae080e7          	jalr	430(ra) # 80005b1e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001978:	00008497          	auipc	s1,0x8
    8000197c:	c6048493          	addi	s1,s1,-928 # 800095d8 <proc+0x158>
    80001980:	0000d917          	auipc	s2,0xd
    80001984:	65890913          	addi	s2,s2,1624 # 8000efd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001988:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000198a:	00007997          	auipc	s3,0x7
    8000198e:	87698993          	addi	s3,s3,-1930 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001992:	00007a97          	auipc	s5,0x7
    80001996:	876a8a93          	addi	s5,s5,-1930 # 80008208 <etext+0x208>
    printf("\n");
    8000199a:	00006a17          	auipc	s4,0x6
    8000199e:	6aea0a13          	addi	s4,s4,1710 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019a2:	00007b97          	auipc	s7,0x7
    800019a6:	89eb8b93          	addi	s7,s7,-1890 # 80008240 <states.0>
    800019aa:	a00d                	j	800019cc <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019ac:	ed86a583          	lw	a1,-296(a3)
    800019b0:	8556                	mv	a0,s5
    800019b2:	00004097          	auipc	ra,0x4
    800019b6:	16c080e7          	jalr	364(ra) # 80005b1e <printf>
    printf("\n");
    800019ba:	8552                	mv	a0,s4
    800019bc:	00004097          	auipc	ra,0x4
    800019c0:	162080e7          	jalr	354(ra) # 80005b1e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019c4:	16848493          	addi	s1,s1,360
    800019c8:	03248163          	beq	s1,s2,800019ea <procdump+0x98>
    if(p->state == UNUSED)
    800019cc:	86a6                	mv	a3,s1
    800019ce:	ec04a783          	lw	a5,-320(s1)
    800019d2:	dbed                	beqz	a5,800019c4 <procdump+0x72>
      state = "???";
    800019d4:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019d6:	fcfb6be3          	bltu	s6,a5,800019ac <procdump+0x5a>
    800019da:	1782                	slli	a5,a5,0x20
    800019dc:	9381                	srli	a5,a5,0x20
    800019de:	078e                	slli	a5,a5,0x3
    800019e0:	97de                	add	a5,a5,s7
    800019e2:	6390                	ld	a2,0(a5)
    800019e4:	f661                	bnez	a2,800019ac <procdump+0x5a>
      state = "???";
    800019e6:	864e                	mv	a2,s3
    800019e8:	b7d1                	j	800019ac <procdump+0x5a>
  }
}
    800019ea:	60a6                	ld	ra,72(sp)
    800019ec:	6406                	ld	s0,64(sp)
    800019ee:	74e2                	ld	s1,56(sp)
    800019f0:	7942                	ld	s2,48(sp)
    800019f2:	79a2                	ld	s3,40(sp)
    800019f4:	7a02                	ld	s4,32(sp)
    800019f6:	6ae2                	ld	s5,24(sp)
    800019f8:	6b42                	ld	s6,16(sp)
    800019fa:	6ba2                	ld	s7,8(sp)
    800019fc:	6161                	addi	sp,sp,80
    800019fe:	8082                	ret

0000000080001a00 <swtch>:
    80001a00:	00153023          	sd	ra,0(a0)
    80001a04:	00253423          	sd	sp,8(a0)
    80001a08:	e900                	sd	s0,16(a0)
    80001a0a:	ed04                	sd	s1,24(a0)
    80001a0c:	03253023          	sd	s2,32(a0)
    80001a10:	03353423          	sd	s3,40(a0)
    80001a14:	03453823          	sd	s4,48(a0)
    80001a18:	03553c23          	sd	s5,56(a0)
    80001a1c:	05653023          	sd	s6,64(a0)
    80001a20:	05753423          	sd	s7,72(a0)
    80001a24:	05853823          	sd	s8,80(a0)
    80001a28:	05953c23          	sd	s9,88(a0)
    80001a2c:	07a53023          	sd	s10,96(a0)
    80001a30:	07b53423          	sd	s11,104(a0)
    80001a34:	0005b083          	ld	ra,0(a1)
    80001a38:	0085b103          	ld	sp,8(a1)
    80001a3c:	6980                	ld	s0,16(a1)
    80001a3e:	6d84                	ld	s1,24(a1)
    80001a40:	0205b903          	ld	s2,32(a1)
    80001a44:	0285b983          	ld	s3,40(a1)
    80001a48:	0305ba03          	ld	s4,48(a1)
    80001a4c:	0385ba83          	ld	s5,56(a1)
    80001a50:	0405bb03          	ld	s6,64(a1)
    80001a54:	0485bb83          	ld	s7,72(a1)
    80001a58:	0505bc03          	ld	s8,80(a1)
    80001a5c:	0585bc83          	ld	s9,88(a1)
    80001a60:	0605bd03          	ld	s10,96(a1)
    80001a64:	0685bd83          	ld	s11,104(a1)
    80001a68:	8082                	ret

0000000080001a6a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001a6a:	1141                	addi	sp,sp,-16
    80001a6c:	e406                	sd	ra,8(sp)
    80001a6e:	e022                	sd	s0,0(sp)
    80001a70:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001a72:	00006597          	auipc	a1,0x6
    80001a76:	7fe58593          	addi	a1,a1,2046 # 80008270 <states.0+0x30>
    80001a7a:	0000d517          	auipc	a0,0xd
    80001a7e:	40650513          	addi	a0,a0,1030 # 8000ee80 <tickslock>
    80001a82:	00004097          	auipc	ra,0x4
    80001a86:	4fe080e7          	jalr	1278(ra) # 80005f80 <initlock>
}
    80001a8a:	60a2                	ld	ra,8(sp)
    80001a8c:	6402                	ld	s0,0(sp)
    80001a8e:	0141                	addi	sp,sp,16
    80001a90:	8082                	ret

0000000080001a92 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001a92:	1141                	addi	sp,sp,-16
    80001a94:	e422                	sd	s0,8(sp)
    80001a96:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a98:	00003797          	auipc	a5,0x3
    80001a9c:	49878793          	addi	a5,a5,1176 # 80004f30 <kernelvec>
    80001aa0:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001aa4:	6422                	ld	s0,8(sp)
    80001aa6:	0141                	addi	sp,sp,16
    80001aa8:	8082                	ret

0000000080001aaa <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001aaa:	1141                	addi	sp,sp,-16
    80001aac:	e406                	sd	ra,8(sp)
    80001aae:	e022                	sd	s0,0(sp)
    80001ab0:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001ab2:	fffff097          	auipc	ra,0xfffff
    80001ab6:	390080e7          	jalr	912(ra) # 80000e42 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001aba:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001abe:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ac0:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001ac4:	00005617          	auipc	a2,0x5
    80001ac8:	53c60613          	addi	a2,a2,1340 # 80007000 <_trampoline>
    80001acc:	00005697          	auipc	a3,0x5
    80001ad0:	53468693          	addi	a3,a3,1332 # 80007000 <_trampoline>
    80001ad4:	8e91                	sub	a3,a3,a2
    80001ad6:	040007b7          	lui	a5,0x4000
    80001ada:	17fd                	addi	a5,a5,-1
    80001adc:	07b2                	slli	a5,a5,0xc
    80001ade:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ae0:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001ae4:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001ae6:	180026f3          	csrr	a3,satp
    80001aea:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001aec:	6d38                	ld	a4,88(a0)
    80001aee:	6134                	ld	a3,64(a0)
    80001af0:	6585                	lui	a1,0x1
    80001af2:	96ae                	add	a3,a3,a1
    80001af4:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001af6:	6d38                	ld	a4,88(a0)
    80001af8:	00000697          	auipc	a3,0x0
    80001afc:	13868693          	addi	a3,a3,312 # 80001c30 <usertrap>
    80001b00:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b02:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b04:	8692                	mv	a3,tp
    80001b06:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b08:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b0c:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b10:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b14:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b18:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b1a:	6f18                	ld	a4,24(a4)
    80001b1c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b20:	692c                	ld	a1,80(a0)
    80001b22:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b24:	00005717          	auipc	a4,0x5
    80001b28:	56c70713          	addi	a4,a4,1388 # 80007090 <userret>
    80001b2c:	8f11                	sub	a4,a4,a2
    80001b2e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b30:	577d                	li	a4,-1
    80001b32:	177e                	slli	a4,a4,0x3f
    80001b34:	8dd9                	or	a1,a1,a4
    80001b36:	02000537          	lui	a0,0x2000
    80001b3a:	157d                	addi	a0,a0,-1
    80001b3c:	0536                	slli	a0,a0,0xd
    80001b3e:	9782                	jalr	a5
}
    80001b40:	60a2                	ld	ra,8(sp)
    80001b42:	6402                	ld	s0,0(sp)
    80001b44:	0141                	addi	sp,sp,16
    80001b46:	8082                	ret

0000000080001b48 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b48:	1101                	addi	sp,sp,-32
    80001b4a:	ec06                	sd	ra,24(sp)
    80001b4c:	e822                	sd	s0,16(sp)
    80001b4e:	e426                	sd	s1,8(sp)
    80001b50:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b52:	0000d497          	auipc	s1,0xd
    80001b56:	32e48493          	addi	s1,s1,814 # 8000ee80 <tickslock>
    80001b5a:	8526                	mv	a0,s1
    80001b5c:	00004097          	auipc	ra,0x4
    80001b60:	4b4080e7          	jalr	1204(ra) # 80006010 <acquire>
  ticks++;
    80001b64:	00007517          	auipc	a0,0x7
    80001b68:	4b450513          	addi	a0,a0,1204 # 80009018 <ticks>
    80001b6c:	411c                	lw	a5,0(a0)
    80001b6e:	2785                	addiw	a5,a5,1
    80001b70:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001b72:	00000097          	auipc	ra,0x0
    80001b76:	b1c080e7          	jalr	-1252(ra) # 8000168e <wakeup>
  release(&tickslock);
    80001b7a:	8526                	mv	a0,s1
    80001b7c:	00004097          	auipc	ra,0x4
    80001b80:	548080e7          	jalr	1352(ra) # 800060c4 <release>
}
    80001b84:	60e2                	ld	ra,24(sp)
    80001b86:	6442                	ld	s0,16(sp)
    80001b88:	64a2                	ld	s1,8(sp)
    80001b8a:	6105                	addi	sp,sp,32
    80001b8c:	8082                	ret

0000000080001b8e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001b8e:	1101                	addi	sp,sp,-32
    80001b90:	ec06                	sd	ra,24(sp)
    80001b92:	e822                	sd	s0,16(sp)
    80001b94:	e426                	sd	s1,8(sp)
    80001b96:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b98:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001b9c:	00074d63          	bltz	a4,80001bb6 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001ba0:	57fd                	li	a5,-1
    80001ba2:	17fe                	slli	a5,a5,0x3f
    80001ba4:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001ba6:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001ba8:	06f70363          	beq	a4,a5,80001c0e <devintr+0x80>
  }
}
    80001bac:	60e2                	ld	ra,24(sp)
    80001bae:	6442                	ld	s0,16(sp)
    80001bb0:	64a2                	ld	s1,8(sp)
    80001bb2:	6105                	addi	sp,sp,32
    80001bb4:	8082                	ret
     (scause & 0xff) == 9){
    80001bb6:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001bba:	46a5                	li	a3,9
    80001bbc:	fed792e3          	bne	a5,a3,80001ba0 <devintr+0x12>
    int irq = plic_claim();
    80001bc0:	00003097          	auipc	ra,0x3
    80001bc4:	478080e7          	jalr	1144(ra) # 80005038 <plic_claim>
    80001bc8:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001bca:	47a9                	li	a5,10
    80001bcc:	02f50763          	beq	a0,a5,80001bfa <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001bd0:	4785                	li	a5,1
    80001bd2:	02f50963          	beq	a0,a5,80001c04 <devintr+0x76>
    return 1;
    80001bd6:	4505                	li	a0,1
    } else if(irq){
    80001bd8:	d8f1                	beqz	s1,80001bac <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001bda:	85a6                	mv	a1,s1
    80001bdc:	00006517          	auipc	a0,0x6
    80001be0:	69c50513          	addi	a0,a0,1692 # 80008278 <states.0+0x38>
    80001be4:	00004097          	auipc	ra,0x4
    80001be8:	f3a080e7          	jalr	-198(ra) # 80005b1e <printf>
      plic_complete(irq);
    80001bec:	8526                	mv	a0,s1
    80001bee:	00003097          	auipc	ra,0x3
    80001bf2:	46e080e7          	jalr	1134(ra) # 8000505c <plic_complete>
    return 1;
    80001bf6:	4505                	li	a0,1
    80001bf8:	bf55                	j	80001bac <devintr+0x1e>
      uartintr();
    80001bfa:	00004097          	auipc	ra,0x4
    80001bfe:	336080e7          	jalr	822(ra) # 80005f30 <uartintr>
    80001c02:	b7ed                	j	80001bec <devintr+0x5e>
      virtio_disk_intr();
    80001c04:	00004097          	auipc	ra,0x4
    80001c08:	8ea080e7          	jalr	-1814(ra) # 800054ee <virtio_disk_intr>
    80001c0c:	b7c5                	j	80001bec <devintr+0x5e>
    if(cpuid() == 0){
    80001c0e:	fffff097          	auipc	ra,0xfffff
    80001c12:	208080e7          	jalr	520(ra) # 80000e16 <cpuid>
    80001c16:	c901                	beqz	a0,80001c26 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c18:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c1c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c1e:	14479073          	csrw	sip,a5
    return 2;
    80001c22:	4509                	li	a0,2
    80001c24:	b761                	j	80001bac <devintr+0x1e>
      clockintr();
    80001c26:	00000097          	auipc	ra,0x0
    80001c2a:	f22080e7          	jalr	-222(ra) # 80001b48 <clockintr>
    80001c2e:	b7ed                	j	80001c18 <devintr+0x8a>

0000000080001c30 <usertrap>:
{
    80001c30:	1101                	addi	sp,sp,-32
    80001c32:	ec06                	sd	ra,24(sp)
    80001c34:	e822                	sd	s0,16(sp)
    80001c36:	e426                	sd	s1,8(sp)
    80001c38:	e04a                	sd	s2,0(sp)
    80001c3a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c3c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c40:	1007f793          	andi	a5,a5,256
    80001c44:	e3ad                	bnez	a5,80001ca6 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c46:	00003797          	auipc	a5,0x3
    80001c4a:	2ea78793          	addi	a5,a5,746 # 80004f30 <kernelvec>
    80001c4e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c52:	fffff097          	auipc	ra,0xfffff
    80001c56:	1f0080e7          	jalr	496(ra) # 80000e42 <myproc>
    80001c5a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001c5c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c5e:	14102773          	csrr	a4,sepc
    80001c62:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c64:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001c68:	47a1                	li	a5,8
    80001c6a:	04f71c63          	bne	a4,a5,80001cc2 <usertrap+0x92>
    if(p->killed)
    80001c6e:	551c                	lw	a5,40(a0)
    80001c70:	e3b9                	bnez	a5,80001cb6 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001c72:	6cb8                	ld	a4,88(s1)
    80001c74:	6f1c                	ld	a5,24(a4)
    80001c76:	0791                	addi	a5,a5,4
    80001c78:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c7a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001c7e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c82:	10079073          	csrw	sstatus,a5
    syscall();
    80001c86:	00000097          	auipc	ra,0x0
    80001c8a:	2e0080e7          	jalr	736(ra) # 80001f66 <syscall>
  if(p->killed)
    80001c8e:	549c                	lw	a5,40(s1)
    80001c90:	ebc1                	bnez	a5,80001d20 <usertrap+0xf0>
  usertrapret();
    80001c92:	00000097          	auipc	ra,0x0
    80001c96:	e18080e7          	jalr	-488(ra) # 80001aaa <usertrapret>
}
    80001c9a:	60e2                	ld	ra,24(sp)
    80001c9c:	6442                	ld	s0,16(sp)
    80001c9e:	64a2                	ld	s1,8(sp)
    80001ca0:	6902                	ld	s2,0(sp)
    80001ca2:	6105                	addi	sp,sp,32
    80001ca4:	8082                	ret
    panic("usertrap: not from user mode");
    80001ca6:	00006517          	auipc	a0,0x6
    80001caa:	5f250513          	addi	a0,a0,1522 # 80008298 <states.0+0x58>
    80001cae:	00004097          	auipc	ra,0x4
    80001cb2:	e26080e7          	jalr	-474(ra) # 80005ad4 <panic>
      exit(-1);
    80001cb6:	557d                	li	a0,-1
    80001cb8:	00000097          	auipc	ra,0x0
    80001cbc:	aa6080e7          	jalr	-1370(ra) # 8000175e <exit>
    80001cc0:	bf4d                	j	80001c72 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001cc2:	00000097          	auipc	ra,0x0
    80001cc6:	ecc080e7          	jalr	-308(ra) # 80001b8e <devintr>
    80001cca:	892a                	mv	s2,a0
    80001ccc:	c501                	beqz	a0,80001cd4 <usertrap+0xa4>
  if(p->killed)
    80001cce:	549c                	lw	a5,40(s1)
    80001cd0:	c3a1                	beqz	a5,80001d10 <usertrap+0xe0>
    80001cd2:	a815                	j	80001d06 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cd4:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001cd8:	5890                	lw	a2,48(s1)
    80001cda:	00006517          	auipc	a0,0x6
    80001cde:	5de50513          	addi	a0,a0,1502 # 800082b8 <states.0+0x78>
    80001ce2:	00004097          	auipc	ra,0x4
    80001ce6:	e3c080e7          	jalr	-452(ra) # 80005b1e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cea:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001cee:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001cf2:	00006517          	auipc	a0,0x6
    80001cf6:	5f650513          	addi	a0,a0,1526 # 800082e8 <states.0+0xa8>
    80001cfa:	00004097          	auipc	ra,0x4
    80001cfe:	e24080e7          	jalr	-476(ra) # 80005b1e <printf>
    p->killed = 1;
    80001d02:	4785                	li	a5,1
    80001d04:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d06:	557d                	li	a0,-1
    80001d08:	00000097          	auipc	ra,0x0
    80001d0c:	a56080e7          	jalr	-1450(ra) # 8000175e <exit>
  if(which_dev == 2)
    80001d10:	4789                	li	a5,2
    80001d12:	f8f910e3          	bne	s2,a5,80001c92 <usertrap+0x62>
    yield();
    80001d16:	fffff097          	auipc	ra,0xfffff
    80001d1a:	7b0080e7          	jalr	1968(ra) # 800014c6 <yield>
    80001d1e:	bf95                	j	80001c92 <usertrap+0x62>
  int which_dev = 0;
    80001d20:	4901                	li	s2,0
    80001d22:	b7d5                	j	80001d06 <usertrap+0xd6>

0000000080001d24 <kerneltrap>:
{
    80001d24:	7179                	addi	sp,sp,-48
    80001d26:	f406                	sd	ra,40(sp)
    80001d28:	f022                	sd	s0,32(sp)
    80001d2a:	ec26                	sd	s1,24(sp)
    80001d2c:	e84a                	sd	s2,16(sp)
    80001d2e:	e44e                	sd	s3,8(sp)
    80001d30:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d32:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d36:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d3a:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001d3e:	1004f793          	andi	a5,s1,256
    80001d42:	cb85                	beqz	a5,80001d72 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d44:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d48:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001d4a:	ef85                	bnez	a5,80001d82 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001d4c:	00000097          	auipc	ra,0x0
    80001d50:	e42080e7          	jalr	-446(ra) # 80001b8e <devintr>
    80001d54:	cd1d                	beqz	a0,80001d92 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001d56:	4789                	li	a5,2
    80001d58:	06f50a63          	beq	a0,a5,80001dcc <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d5c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d60:	10049073          	csrw	sstatus,s1
}
    80001d64:	70a2                	ld	ra,40(sp)
    80001d66:	7402                	ld	s0,32(sp)
    80001d68:	64e2                	ld	s1,24(sp)
    80001d6a:	6942                	ld	s2,16(sp)
    80001d6c:	69a2                	ld	s3,8(sp)
    80001d6e:	6145                	addi	sp,sp,48
    80001d70:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001d72:	00006517          	auipc	a0,0x6
    80001d76:	59650513          	addi	a0,a0,1430 # 80008308 <states.0+0xc8>
    80001d7a:	00004097          	auipc	ra,0x4
    80001d7e:	d5a080e7          	jalr	-678(ra) # 80005ad4 <panic>
    panic("kerneltrap: interrupts enabled");
    80001d82:	00006517          	auipc	a0,0x6
    80001d86:	5ae50513          	addi	a0,a0,1454 # 80008330 <states.0+0xf0>
    80001d8a:	00004097          	auipc	ra,0x4
    80001d8e:	d4a080e7          	jalr	-694(ra) # 80005ad4 <panic>
    printf("scause %p\n", scause);
    80001d92:	85ce                	mv	a1,s3
    80001d94:	00006517          	auipc	a0,0x6
    80001d98:	5bc50513          	addi	a0,a0,1468 # 80008350 <states.0+0x110>
    80001d9c:	00004097          	auipc	ra,0x4
    80001da0:	d82080e7          	jalr	-638(ra) # 80005b1e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001da4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001da8:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001dac:	00006517          	auipc	a0,0x6
    80001db0:	5b450513          	addi	a0,a0,1460 # 80008360 <states.0+0x120>
    80001db4:	00004097          	auipc	ra,0x4
    80001db8:	d6a080e7          	jalr	-662(ra) # 80005b1e <printf>
    panic("kerneltrap");
    80001dbc:	00006517          	auipc	a0,0x6
    80001dc0:	5bc50513          	addi	a0,a0,1468 # 80008378 <states.0+0x138>
    80001dc4:	00004097          	auipc	ra,0x4
    80001dc8:	d10080e7          	jalr	-752(ra) # 80005ad4 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dcc:	fffff097          	auipc	ra,0xfffff
    80001dd0:	076080e7          	jalr	118(ra) # 80000e42 <myproc>
    80001dd4:	d541                	beqz	a0,80001d5c <kerneltrap+0x38>
    80001dd6:	fffff097          	auipc	ra,0xfffff
    80001dda:	06c080e7          	jalr	108(ra) # 80000e42 <myproc>
    80001dde:	4d18                	lw	a4,24(a0)
    80001de0:	4791                	li	a5,4
    80001de2:	f6f71de3          	bne	a4,a5,80001d5c <kerneltrap+0x38>
    yield();
    80001de6:	fffff097          	auipc	ra,0xfffff
    80001dea:	6e0080e7          	jalr	1760(ra) # 800014c6 <yield>
    80001dee:	b7bd                	j	80001d5c <kerneltrap+0x38>

0000000080001df0 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001df0:	1101                	addi	sp,sp,-32
    80001df2:	ec06                	sd	ra,24(sp)
    80001df4:	e822                	sd	s0,16(sp)
    80001df6:	e426                	sd	s1,8(sp)
    80001df8:	1000                	addi	s0,sp,32
    80001dfa:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001dfc:	fffff097          	auipc	ra,0xfffff
    80001e00:	046080e7          	jalr	70(ra) # 80000e42 <myproc>
  switch (n) {
    80001e04:	4795                	li	a5,5
    80001e06:	0497e163          	bltu	a5,s1,80001e48 <argraw+0x58>
    80001e0a:	048a                	slli	s1,s1,0x2
    80001e0c:	00006717          	auipc	a4,0x6
    80001e10:	5a470713          	addi	a4,a4,1444 # 800083b0 <states.0+0x170>
    80001e14:	94ba                	add	s1,s1,a4
    80001e16:	409c                	lw	a5,0(s1)
    80001e18:	97ba                	add	a5,a5,a4
    80001e1a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e1c:	6d3c                	ld	a5,88(a0)
    80001e1e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e20:	60e2                	ld	ra,24(sp)
    80001e22:	6442                	ld	s0,16(sp)
    80001e24:	64a2                	ld	s1,8(sp)
    80001e26:	6105                	addi	sp,sp,32
    80001e28:	8082                	ret
    return p->trapframe->a1;
    80001e2a:	6d3c                	ld	a5,88(a0)
    80001e2c:	7fa8                	ld	a0,120(a5)
    80001e2e:	bfcd                	j	80001e20 <argraw+0x30>
    return p->trapframe->a2;
    80001e30:	6d3c                	ld	a5,88(a0)
    80001e32:	63c8                	ld	a0,128(a5)
    80001e34:	b7f5                	j	80001e20 <argraw+0x30>
    return p->trapframe->a3;
    80001e36:	6d3c                	ld	a5,88(a0)
    80001e38:	67c8                	ld	a0,136(a5)
    80001e3a:	b7dd                	j	80001e20 <argraw+0x30>
    return p->trapframe->a4;
    80001e3c:	6d3c                	ld	a5,88(a0)
    80001e3e:	6bc8                	ld	a0,144(a5)
    80001e40:	b7c5                	j	80001e20 <argraw+0x30>
    return p->trapframe->a5;
    80001e42:	6d3c                	ld	a5,88(a0)
    80001e44:	6fc8                	ld	a0,152(a5)
    80001e46:	bfe9                	j	80001e20 <argraw+0x30>
  panic("argraw");
    80001e48:	00006517          	auipc	a0,0x6
    80001e4c:	54050513          	addi	a0,a0,1344 # 80008388 <states.0+0x148>
    80001e50:	00004097          	auipc	ra,0x4
    80001e54:	c84080e7          	jalr	-892(ra) # 80005ad4 <panic>

0000000080001e58 <fetchaddr>:
{
    80001e58:	1101                	addi	sp,sp,-32
    80001e5a:	ec06                	sd	ra,24(sp)
    80001e5c:	e822                	sd	s0,16(sp)
    80001e5e:	e426                	sd	s1,8(sp)
    80001e60:	e04a                	sd	s2,0(sp)
    80001e62:	1000                	addi	s0,sp,32
    80001e64:	84aa                	mv	s1,a0
    80001e66:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001e68:	fffff097          	auipc	ra,0xfffff
    80001e6c:	fda080e7          	jalr	-38(ra) # 80000e42 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001e70:	653c                	ld	a5,72(a0)
    80001e72:	02f4f863          	bgeu	s1,a5,80001ea2 <fetchaddr+0x4a>
    80001e76:	00848713          	addi	a4,s1,8
    80001e7a:	02e7e663          	bltu	a5,a4,80001ea6 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001e7e:	46a1                	li	a3,8
    80001e80:	8626                	mv	a2,s1
    80001e82:	85ca                	mv	a1,s2
    80001e84:	6928                	ld	a0,80(a0)
    80001e86:	fffff097          	auipc	ra,0xfffff
    80001e8a:	d08080e7          	jalr	-760(ra) # 80000b8e <copyin>
    80001e8e:	00a03533          	snez	a0,a0
    80001e92:	40a00533          	neg	a0,a0
}
    80001e96:	60e2                	ld	ra,24(sp)
    80001e98:	6442                	ld	s0,16(sp)
    80001e9a:	64a2                	ld	s1,8(sp)
    80001e9c:	6902                	ld	s2,0(sp)
    80001e9e:	6105                	addi	sp,sp,32
    80001ea0:	8082                	ret
    return -1;
    80001ea2:	557d                	li	a0,-1
    80001ea4:	bfcd                	j	80001e96 <fetchaddr+0x3e>
    80001ea6:	557d                	li	a0,-1
    80001ea8:	b7fd                	j	80001e96 <fetchaddr+0x3e>

0000000080001eaa <fetchstr>:
{
    80001eaa:	7179                	addi	sp,sp,-48
    80001eac:	f406                	sd	ra,40(sp)
    80001eae:	f022                	sd	s0,32(sp)
    80001eb0:	ec26                	sd	s1,24(sp)
    80001eb2:	e84a                	sd	s2,16(sp)
    80001eb4:	e44e                	sd	s3,8(sp)
    80001eb6:	1800                	addi	s0,sp,48
    80001eb8:	892a                	mv	s2,a0
    80001eba:	84ae                	mv	s1,a1
    80001ebc:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001ebe:	fffff097          	auipc	ra,0xfffff
    80001ec2:	f84080e7          	jalr	-124(ra) # 80000e42 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001ec6:	86ce                	mv	a3,s3
    80001ec8:	864a                	mv	a2,s2
    80001eca:	85a6                	mv	a1,s1
    80001ecc:	6928                	ld	a0,80(a0)
    80001ece:	fffff097          	auipc	ra,0xfffff
    80001ed2:	d4e080e7          	jalr	-690(ra) # 80000c1c <copyinstr>
  if(err < 0)
    80001ed6:	00054763          	bltz	a0,80001ee4 <fetchstr+0x3a>
  return strlen(buf);
    80001eda:	8526                	mv	a0,s1
    80001edc:	ffffe097          	auipc	ra,0xffffe
    80001ee0:	418080e7          	jalr	1048(ra) # 800002f4 <strlen>
}
    80001ee4:	70a2                	ld	ra,40(sp)
    80001ee6:	7402                	ld	s0,32(sp)
    80001ee8:	64e2                	ld	s1,24(sp)
    80001eea:	6942                	ld	s2,16(sp)
    80001eec:	69a2                	ld	s3,8(sp)
    80001eee:	6145                	addi	sp,sp,48
    80001ef0:	8082                	ret

0000000080001ef2 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001ef2:	1101                	addi	sp,sp,-32
    80001ef4:	ec06                	sd	ra,24(sp)
    80001ef6:	e822                	sd	s0,16(sp)
    80001ef8:	e426                	sd	s1,8(sp)
    80001efa:	1000                	addi	s0,sp,32
    80001efc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001efe:	00000097          	auipc	ra,0x0
    80001f02:	ef2080e7          	jalr	-270(ra) # 80001df0 <argraw>
    80001f06:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f08:	4501                	li	a0,0
    80001f0a:	60e2                	ld	ra,24(sp)
    80001f0c:	6442                	ld	s0,16(sp)
    80001f0e:	64a2                	ld	s1,8(sp)
    80001f10:	6105                	addi	sp,sp,32
    80001f12:	8082                	ret

0000000080001f14 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f14:	1101                	addi	sp,sp,-32
    80001f16:	ec06                	sd	ra,24(sp)
    80001f18:	e822                	sd	s0,16(sp)
    80001f1a:	e426                	sd	s1,8(sp)
    80001f1c:	1000                	addi	s0,sp,32
    80001f1e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f20:	00000097          	auipc	ra,0x0
    80001f24:	ed0080e7          	jalr	-304(ra) # 80001df0 <argraw>
    80001f28:	e088                	sd	a0,0(s1)
  return 0;
}
    80001f2a:	4501                	li	a0,0
    80001f2c:	60e2                	ld	ra,24(sp)
    80001f2e:	6442                	ld	s0,16(sp)
    80001f30:	64a2                	ld	s1,8(sp)
    80001f32:	6105                	addi	sp,sp,32
    80001f34:	8082                	ret

0000000080001f36 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001f36:	1101                	addi	sp,sp,-32
    80001f38:	ec06                	sd	ra,24(sp)
    80001f3a:	e822                	sd	s0,16(sp)
    80001f3c:	e426                	sd	s1,8(sp)
    80001f3e:	e04a                	sd	s2,0(sp)
    80001f40:	1000                	addi	s0,sp,32
    80001f42:	84ae                	mv	s1,a1
    80001f44:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001f46:	00000097          	auipc	ra,0x0
    80001f4a:	eaa080e7          	jalr	-342(ra) # 80001df0 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001f4e:	864a                	mv	a2,s2
    80001f50:	85a6                	mv	a1,s1
    80001f52:	00000097          	auipc	ra,0x0
    80001f56:	f58080e7          	jalr	-168(ra) # 80001eaa <fetchstr>
}
    80001f5a:	60e2                	ld	ra,24(sp)
    80001f5c:	6442                	ld	s0,16(sp)
    80001f5e:	64a2                	ld	s1,8(sp)
    80001f60:	6902                	ld	s2,0(sp)
    80001f62:	6105                	addi	sp,sp,32
    80001f64:	8082                	ret

0000000080001f66 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80001f66:	1101                	addi	sp,sp,-32
    80001f68:	ec06                	sd	ra,24(sp)
    80001f6a:	e822                	sd	s0,16(sp)
    80001f6c:	e426                	sd	s1,8(sp)
    80001f6e:	e04a                	sd	s2,0(sp)
    80001f70:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001f72:	fffff097          	auipc	ra,0xfffff
    80001f76:	ed0080e7          	jalr	-304(ra) # 80000e42 <myproc>
    80001f7a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001f7c:	05853903          	ld	s2,88(a0)
    80001f80:	0a893783          	ld	a5,168(s2)
    80001f84:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001f88:	37fd                	addiw	a5,a5,-1
    80001f8a:	4751                	li	a4,20
    80001f8c:	00f76f63          	bltu	a4,a5,80001faa <syscall+0x44>
    80001f90:	00369713          	slli	a4,a3,0x3
    80001f94:	00006797          	auipc	a5,0x6
    80001f98:	43478793          	addi	a5,a5,1076 # 800083c8 <syscalls>
    80001f9c:	97ba                	add	a5,a5,a4
    80001f9e:	639c                	ld	a5,0(a5)
    80001fa0:	c789                	beqz	a5,80001faa <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80001fa2:	9782                	jalr	a5
    80001fa4:	06a93823          	sd	a0,112(s2)
    80001fa8:	a839                	j	80001fc6 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001faa:	15848613          	addi	a2,s1,344
    80001fae:	588c                	lw	a1,48(s1)
    80001fb0:	00006517          	auipc	a0,0x6
    80001fb4:	3e050513          	addi	a0,a0,992 # 80008390 <states.0+0x150>
    80001fb8:	00004097          	auipc	ra,0x4
    80001fbc:	b66080e7          	jalr	-1178(ra) # 80005b1e <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001fc0:	6cbc                	ld	a5,88(s1)
    80001fc2:	577d                	li	a4,-1
    80001fc4:	fbb8                	sd	a4,112(a5)
  }
}
    80001fc6:	60e2                	ld	ra,24(sp)
    80001fc8:	6442                	ld	s0,16(sp)
    80001fca:	64a2                	ld	s1,8(sp)
    80001fcc:	6902                	ld	s2,0(sp)
    80001fce:	6105                	addi	sp,sp,32
    80001fd0:	8082                	ret

0000000080001fd2 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80001fd2:	1101                	addi	sp,sp,-32
    80001fd4:	ec06                	sd	ra,24(sp)
    80001fd6:	e822                	sd	s0,16(sp)
    80001fd8:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80001fda:	fec40593          	addi	a1,s0,-20
    80001fde:	4501                	li	a0,0
    80001fe0:	00000097          	auipc	ra,0x0
    80001fe4:	f12080e7          	jalr	-238(ra) # 80001ef2 <argint>
    return -1;
    80001fe8:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80001fea:	00054963          	bltz	a0,80001ffc <sys_exit+0x2a>
  exit(n);
    80001fee:	fec42503          	lw	a0,-20(s0)
    80001ff2:	fffff097          	auipc	ra,0xfffff
    80001ff6:	76c080e7          	jalr	1900(ra) # 8000175e <exit>
  return 0;  // not reached
    80001ffa:	4781                	li	a5,0
}
    80001ffc:	853e                	mv	a0,a5
    80001ffe:	60e2                	ld	ra,24(sp)
    80002000:	6442                	ld	s0,16(sp)
    80002002:	6105                	addi	sp,sp,32
    80002004:	8082                	ret

0000000080002006 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002006:	1141                	addi	sp,sp,-16
    80002008:	e406                	sd	ra,8(sp)
    8000200a:	e022                	sd	s0,0(sp)
    8000200c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000200e:	fffff097          	auipc	ra,0xfffff
    80002012:	e34080e7          	jalr	-460(ra) # 80000e42 <myproc>
}
    80002016:	5908                	lw	a0,48(a0)
    80002018:	60a2                	ld	ra,8(sp)
    8000201a:	6402                	ld	s0,0(sp)
    8000201c:	0141                	addi	sp,sp,16
    8000201e:	8082                	ret

0000000080002020 <sys_fork>:

uint64
sys_fork(void)
{
    80002020:	1141                	addi	sp,sp,-16
    80002022:	e406                	sd	ra,8(sp)
    80002024:	e022                	sd	s0,0(sp)
    80002026:	0800                	addi	s0,sp,16
  return fork();
    80002028:	fffff097          	auipc	ra,0xfffff
    8000202c:	1e8080e7          	jalr	488(ra) # 80001210 <fork>
}
    80002030:	60a2                	ld	ra,8(sp)
    80002032:	6402                	ld	s0,0(sp)
    80002034:	0141                	addi	sp,sp,16
    80002036:	8082                	ret

0000000080002038 <sys_wait>:

uint64
sys_wait(void)
{
    80002038:	1101                	addi	sp,sp,-32
    8000203a:	ec06                	sd	ra,24(sp)
    8000203c:	e822                	sd	s0,16(sp)
    8000203e:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002040:	fe840593          	addi	a1,s0,-24
    80002044:	4501                	li	a0,0
    80002046:	00000097          	auipc	ra,0x0
    8000204a:	ece080e7          	jalr	-306(ra) # 80001f14 <argaddr>
    8000204e:	87aa                	mv	a5,a0
    return -1;
    80002050:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002052:	0007c863          	bltz	a5,80002062 <sys_wait+0x2a>
  return wait(p);
    80002056:	fe843503          	ld	a0,-24(s0)
    8000205a:	fffff097          	auipc	ra,0xfffff
    8000205e:	50c080e7          	jalr	1292(ra) # 80001566 <wait>
}
    80002062:	60e2                	ld	ra,24(sp)
    80002064:	6442                	ld	s0,16(sp)
    80002066:	6105                	addi	sp,sp,32
    80002068:	8082                	ret

000000008000206a <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000206a:	7179                	addi	sp,sp,-48
    8000206c:	f406                	sd	ra,40(sp)
    8000206e:	f022                	sd	s0,32(sp)
    80002070:	ec26                	sd	s1,24(sp)
    80002072:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002074:	fdc40593          	addi	a1,s0,-36
    80002078:	4501                	li	a0,0
    8000207a:	00000097          	auipc	ra,0x0
    8000207e:	e78080e7          	jalr	-392(ra) # 80001ef2 <argint>
    return -1;
    80002082:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    80002084:	00054f63          	bltz	a0,800020a2 <sys_sbrk+0x38>
  addr = myproc()->sz;
    80002088:	fffff097          	auipc	ra,0xfffff
    8000208c:	dba080e7          	jalr	-582(ra) # 80000e42 <myproc>
    80002090:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002092:	fdc42503          	lw	a0,-36(s0)
    80002096:	fffff097          	auipc	ra,0xfffff
    8000209a:	106080e7          	jalr	262(ra) # 8000119c <growproc>
    8000209e:	00054863          	bltz	a0,800020ae <sys_sbrk+0x44>
    return -1;
  return addr;
}
    800020a2:	8526                	mv	a0,s1
    800020a4:	70a2                	ld	ra,40(sp)
    800020a6:	7402                	ld	s0,32(sp)
    800020a8:	64e2                	ld	s1,24(sp)
    800020aa:	6145                	addi	sp,sp,48
    800020ac:	8082                	ret
    return -1;
    800020ae:	54fd                	li	s1,-1
    800020b0:	bfcd                	j	800020a2 <sys_sbrk+0x38>

00000000800020b2 <sys_sleep>:

uint64
sys_sleep(void)
{
    800020b2:	7139                	addi	sp,sp,-64
    800020b4:	fc06                	sd	ra,56(sp)
    800020b6:	f822                	sd	s0,48(sp)
    800020b8:	f426                	sd	s1,40(sp)
    800020ba:	f04a                	sd	s2,32(sp)
    800020bc:	ec4e                	sd	s3,24(sp)
    800020be:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800020c0:	fcc40593          	addi	a1,s0,-52
    800020c4:	4501                	li	a0,0
    800020c6:	00000097          	auipc	ra,0x0
    800020ca:	e2c080e7          	jalr	-468(ra) # 80001ef2 <argint>
    return -1;
    800020ce:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020d0:	06054563          	bltz	a0,8000213a <sys_sleep+0x88>
  acquire(&tickslock);
    800020d4:	0000d517          	auipc	a0,0xd
    800020d8:	dac50513          	addi	a0,a0,-596 # 8000ee80 <tickslock>
    800020dc:	00004097          	auipc	ra,0x4
    800020e0:	f34080e7          	jalr	-204(ra) # 80006010 <acquire>
  ticks0 = ticks;
    800020e4:	00007917          	auipc	s2,0x7
    800020e8:	f3492903          	lw	s2,-204(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800020ec:	fcc42783          	lw	a5,-52(s0)
    800020f0:	cf85                	beqz	a5,80002128 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800020f2:	0000d997          	auipc	s3,0xd
    800020f6:	d8e98993          	addi	s3,s3,-626 # 8000ee80 <tickslock>
    800020fa:	00007497          	auipc	s1,0x7
    800020fe:	f1e48493          	addi	s1,s1,-226 # 80009018 <ticks>
    if(myproc()->killed){
    80002102:	fffff097          	auipc	ra,0xfffff
    80002106:	d40080e7          	jalr	-704(ra) # 80000e42 <myproc>
    8000210a:	551c                	lw	a5,40(a0)
    8000210c:	ef9d                	bnez	a5,8000214a <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    8000210e:	85ce                	mv	a1,s3
    80002110:	8526                	mv	a0,s1
    80002112:	fffff097          	auipc	ra,0xfffff
    80002116:	3f0080e7          	jalr	1008(ra) # 80001502 <sleep>
  while(ticks - ticks0 < n){
    8000211a:	409c                	lw	a5,0(s1)
    8000211c:	412787bb          	subw	a5,a5,s2
    80002120:	fcc42703          	lw	a4,-52(s0)
    80002124:	fce7efe3          	bltu	a5,a4,80002102 <sys_sleep+0x50>
  }
  release(&tickslock);
    80002128:	0000d517          	auipc	a0,0xd
    8000212c:	d5850513          	addi	a0,a0,-680 # 8000ee80 <tickslock>
    80002130:	00004097          	auipc	ra,0x4
    80002134:	f94080e7          	jalr	-108(ra) # 800060c4 <release>
  return 0;
    80002138:	4781                	li	a5,0
}
    8000213a:	853e                	mv	a0,a5
    8000213c:	70e2                	ld	ra,56(sp)
    8000213e:	7442                	ld	s0,48(sp)
    80002140:	74a2                	ld	s1,40(sp)
    80002142:	7902                	ld	s2,32(sp)
    80002144:	69e2                	ld	s3,24(sp)
    80002146:	6121                	addi	sp,sp,64
    80002148:	8082                	ret
      release(&tickslock);
    8000214a:	0000d517          	auipc	a0,0xd
    8000214e:	d3650513          	addi	a0,a0,-714 # 8000ee80 <tickslock>
    80002152:	00004097          	auipc	ra,0x4
    80002156:	f72080e7          	jalr	-142(ra) # 800060c4 <release>
      return -1;
    8000215a:	57fd                	li	a5,-1
    8000215c:	bff9                	j	8000213a <sys_sleep+0x88>

000000008000215e <sys_kill>:

uint64
sys_kill(void)
{
    8000215e:	1101                	addi	sp,sp,-32
    80002160:	ec06                	sd	ra,24(sp)
    80002162:	e822                	sd	s0,16(sp)
    80002164:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002166:	fec40593          	addi	a1,s0,-20
    8000216a:	4501                	li	a0,0
    8000216c:	00000097          	auipc	ra,0x0
    80002170:	d86080e7          	jalr	-634(ra) # 80001ef2 <argint>
    80002174:	87aa                	mv	a5,a0
    return -1;
    80002176:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002178:	0007c863          	bltz	a5,80002188 <sys_kill+0x2a>
  return kill(pid);
    8000217c:	fec42503          	lw	a0,-20(s0)
    80002180:	fffff097          	auipc	ra,0xfffff
    80002184:	6b4080e7          	jalr	1716(ra) # 80001834 <kill>
}
    80002188:	60e2                	ld	ra,24(sp)
    8000218a:	6442                	ld	s0,16(sp)
    8000218c:	6105                	addi	sp,sp,32
    8000218e:	8082                	ret

0000000080002190 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002190:	1101                	addi	sp,sp,-32
    80002192:	ec06                	sd	ra,24(sp)
    80002194:	e822                	sd	s0,16(sp)
    80002196:	e426                	sd	s1,8(sp)
    80002198:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000219a:	0000d517          	auipc	a0,0xd
    8000219e:	ce650513          	addi	a0,a0,-794 # 8000ee80 <tickslock>
    800021a2:	00004097          	auipc	ra,0x4
    800021a6:	e6e080e7          	jalr	-402(ra) # 80006010 <acquire>
  xticks = ticks;
    800021aa:	00007497          	auipc	s1,0x7
    800021ae:	e6e4a483          	lw	s1,-402(s1) # 80009018 <ticks>
  release(&tickslock);
    800021b2:	0000d517          	auipc	a0,0xd
    800021b6:	cce50513          	addi	a0,a0,-818 # 8000ee80 <tickslock>
    800021ba:	00004097          	auipc	ra,0x4
    800021be:	f0a080e7          	jalr	-246(ra) # 800060c4 <release>
  return xticks;
}
    800021c2:	02049513          	slli	a0,s1,0x20
    800021c6:	9101                	srli	a0,a0,0x20
    800021c8:	60e2                	ld	ra,24(sp)
    800021ca:	6442                	ld	s0,16(sp)
    800021cc:	64a2                	ld	s1,8(sp)
    800021ce:	6105                	addi	sp,sp,32
    800021d0:	8082                	ret

00000000800021d2 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800021d2:	7179                	addi	sp,sp,-48
    800021d4:	f406                	sd	ra,40(sp)
    800021d6:	f022                	sd	s0,32(sp)
    800021d8:	ec26                	sd	s1,24(sp)
    800021da:	e84a                	sd	s2,16(sp)
    800021dc:	e44e                	sd	s3,8(sp)
    800021de:	e052                	sd	s4,0(sp)
    800021e0:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800021e2:	00006597          	auipc	a1,0x6
    800021e6:	29658593          	addi	a1,a1,662 # 80008478 <syscalls+0xb0>
    800021ea:	0000d517          	auipc	a0,0xd
    800021ee:	cae50513          	addi	a0,a0,-850 # 8000ee98 <bcache>
    800021f2:	00004097          	auipc	ra,0x4
    800021f6:	d8e080e7          	jalr	-626(ra) # 80005f80 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800021fa:	00015797          	auipc	a5,0x15
    800021fe:	c9e78793          	addi	a5,a5,-866 # 80016e98 <bcache+0x8000>
    80002202:	00015717          	auipc	a4,0x15
    80002206:	efe70713          	addi	a4,a4,-258 # 80017100 <bcache+0x8268>
    8000220a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000220e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002212:	0000d497          	auipc	s1,0xd
    80002216:	c9e48493          	addi	s1,s1,-866 # 8000eeb0 <bcache+0x18>
    b->next = bcache.head.next;
    8000221a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000221c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000221e:	00006a17          	auipc	s4,0x6
    80002222:	262a0a13          	addi	s4,s4,610 # 80008480 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002226:	2b893783          	ld	a5,696(s2)
    8000222a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000222c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002230:	85d2                	mv	a1,s4
    80002232:	01048513          	addi	a0,s1,16
    80002236:	00001097          	auipc	ra,0x1
    8000223a:	4bc080e7          	jalr	1212(ra) # 800036f2 <initsleeplock>
    bcache.head.next->prev = b;
    8000223e:	2b893783          	ld	a5,696(s2)
    80002242:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002244:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002248:	45848493          	addi	s1,s1,1112
    8000224c:	fd349de3          	bne	s1,s3,80002226 <binit+0x54>
  }
}
    80002250:	70a2                	ld	ra,40(sp)
    80002252:	7402                	ld	s0,32(sp)
    80002254:	64e2                	ld	s1,24(sp)
    80002256:	6942                	ld	s2,16(sp)
    80002258:	69a2                	ld	s3,8(sp)
    8000225a:	6a02                	ld	s4,0(sp)
    8000225c:	6145                	addi	sp,sp,48
    8000225e:	8082                	ret

0000000080002260 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002260:	7179                	addi	sp,sp,-48
    80002262:	f406                	sd	ra,40(sp)
    80002264:	f022                	sd	s0,32(sp)
    80002266:	ec26                	sd	s1,24(sp)
    80002268:	e84a                	sd	s2,16(sp)
    8000226a:	e44e                	sd	s3,8(sp)
    8000226c:	1800                	addi	s0,sp,48
    8000226e:	892a                	mv	s2,a0
    80002270:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002272:	0000d517          	auipc	a0,0xd
    80002276:	c2650513          	addi	a0,a0,-986 # 8000ee98 <bcache>
    8000227a:	00004097          	auipc	ra,0x4
    8000227e:	d96080e7          	jalr	-618(ra) # 80006010 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002282:	00015497          	auipc	s1,0x15
    80002286:	ece4b483          	ld	s1,-306(s1) # 80017150 <bcache+0x82b8>
    8000228a:	00015797          	auipc	a5,0x15
    8000228e:	e7678793          	addi	a5,a5,-394 # 80017100 <bcache+0x8268>
    80002292:	02f48f63          	beq	s1,a5,800022d0 <bread+0x70>
    80002296:	873e                	mv	a4,a5
    80002298:	a021                	j	800022a0 <bread+0x40>
    8000229a:	68a4                	ld	s1,80(s1)
    8000229c:	02e48a63          	beq	s1,a4,800022d0 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800022a0:	449c                	lw	a5,8(s1)
    800022a2:	ff279ce3          	bne	a5,s2,8000229a <bread+0x3a>
    800022a6:	44dc                	lw	a5,12(s1)
    800022a8:	ff3799e3          	bne	a5,s3,8000229a <bread+0x3a>
      b->refcnt++;
    800022ac:	40bc                	lw	a5,64(s1)
    800022ae:	2785                	addiw	a5,a5,1
    800022b0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800022b2:	0000d517          	auipc	a0,0xd
    800022b6:	be650513          	addi	a0,a0,-1050 # 8000ee98 <bcache>
    800022ba:	00004097          	auipc	ra,0x4
    800022be:	e0a080e7          	jalr	-502(ra) # 800060c4 <release>
      acquiresleep(&b->lock);
    800022c2:	01048513          	addi	a0,s1,16
    800022c6:	00001097          	auipc	ra,0x1
    800022ca:	466080e7          	jalr	1126(ra) # 8000372c <acquiresleep>
      return b;
    800022ce:	a8b9                	j	8000232c <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800022d0:	00015497          	auipc	s1,0x15
    800022d4:	e784b483          	ld	s1,-392(s1) # 80017148 <bcache+0x82b0>
    800022d8:	00015797          	auipc	a5,0x15
    800022dc:	e2878793          	addi	a5,a5,-472 # 80017100 <bcache+0x8268>
    800022e0:	00f48863          	beq	s1,a5,800022f0 <bread+0x90>
    800022e4:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800022e6:	40bc                	lw	a5,64(s1)
    800022e8:	cf81                	beqz	a5,80002300 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800022ea:	64a4                	ld	s1,72(s1)
    800022ec:	fee49de3          	bne	s1,a4,800022e6 <bread+0x86>
  panic("bget: no buffers");
    800022f0:	00006517          	auipc	a0,0x6
    800022f4:	19850513          	addi	a0,a0,408 # 80008488 <syscalls+0xc0>
    800022f8:	00003097          	auipc	ra,0x3
    800022fc:	7dc080e7          	jalr	2012(ra) # 80005ad4 <panic>
      b->dev = dev;
    80002300:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002304:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002308:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000230c:	4785                	li	a5,1
    8000230e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002310:	0000d517          	auipc	a0,0xd
    80002314:	b8850513          	addi	a0,a0,-1144 # 8000ee98 <bcache>
    80002318:	00004097          	auipc	ra,0x4
    8000231c:	dac080e7          	jalr	-596(ra) # 800060c4 <release>
      acquiresleep(&b->lock);
    80002320:	01048513          	addi	a0,s1,16
    80002324:	00001097          	auipc	ra,0x1
    80002328:	408080e7          	jalr	1032(ra) # 8000372c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000232c:	409c                	lw	a5,0(s1)
    8000232e:	cb89                	beqz	a5,80002340 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002330:	8526                	mv	a0,s1
    80002332:	70a2                	ld	ra,40(sp)
    80002334:	7402                	ld	s0,32(sp)
    80002336:	64e2                	ld	s1,24(sp)
    80002338:	6942                	ld	s2,16(sp)
    8000233a:	69a2                	ld	s3,8(sp)
    8000233c:	6145                	addi	sp,sp,48
    8000233e:	8082                	ret
    virtio_disk_rw(b, 0);
    80002340:	4581                	li	a1,0
    80002342:	8526                	mv	a0,s1
    80002344:	00003097          	auipc	ra,0x3
    80002348:	f22080e7          	jalr	-222(ra) # 80005266 <virtio_disk_rw>
    b->valid = 1;
    8000234c:	4785                	li	a5,1
    8000234e:	c09c                	sw	a5,0(s1)
  return b;
    80002350:	b7c5                	j	80002330 <bread+0xd0>

0000000080002352 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002352:	1101                	addi	sp,sp,-32
    80002354:	ec06                	sd	ra,24(sp)
    80002356:	e822                	sd	s0,16(sp)
    80002358:	e426                	sd	s1,8(sp)
    8000235a:	1000                	addi	s0,sp,32
    8000235c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000235e:	0541                	addi	a0,a0,16
    80002360:	00001097          	auipc	ra,0x1
    80002364:	466080e7          	jalr	1126(ra) # 800037c6 <holdingsleep>
    80002368:	cd01                	beqz	a0,80002380 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000236a:	4585                	li	a1,1
    8000236c:	8526                	mv	a0,s1
    8000236e:	00003097          	auipc	ra,0x3
    80002372:	ef8080e7          	jalr	-264(ra) # 80005266 <virtio_disk_rw>
}
    80002376:	60e2                	ld	ra,24(sp)
    80002378:	6442                	ld	s0,16(sp)
    8000237a:	64a2                	ld	s1,8(sp)
    8000237c:	6105                	addi	sp,sp,32
    8000237e:	8082                	ret
    panic("bwrite");
    80002380:	00006517          	auipc	a0,0x6
    80002384:	12050513          	addi	a0,a0,288 # 800084a0 <syscalls+0xd8>
    80002388:	00003097          	auipc	ra,0x3
    8000238c:	74c080e7          	jalr	1868(ra) # 80005ad4 <panic>

0000000080002390 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002390:	1101                	addi	sp,sp,-32
    80002392:	ec06                	sd	ra,24(sp)
    80002394:	e822                	sd	s0,16(sp)
    80002396:	e426                	sd	s1,8(sp)
    80002398:	e04a                	sd	s2,0(sp)
    8000239a:	1000                	addi	s0,sp,32
    8000239c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000239e:	01050913          	addi	s2,a0,16
    800023a2:	854a                	mv	a0,s2
    800023a4:	00001097          	auipc	ra,0x1
    800023a8:	422080e7          	jalr	1058(ra) # 800037c6 <holdingsleep>
    800023ac:	c92d                	beqz	a0,8000241e <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800023ae:	854a                	mv	a0,s2
    800023b0:	00001097          	auipc	ra,0x1
    800023b4:	3d2080e7          	jalr	978(ra) # 80003782 <releasesleep>

  acquire(&bcache.lock);
    800023b8:	0000d517          	auipc	a0,0xd
    800023bc:	ae050513          	addi	a0,a0,-1312 # 8000ee98 <bcache>
    800023c0:	00004097          	auipc	ra,0x4
    800023c4:	c50080e7          	jalr	-944(ra) # 80006010 <acquire>
  b->refcnt--;
    800023c8:	40bc                	lw	a5,64(s1)
    800023ca:	37fd                	addiw	a5,a5,-1
    800023cc:	0007871b          	sext.w	a4,a5
    800023d0:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800023d2:	eb05                	bnez	a4,80002402 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800023d4:	68bc                	ld	a5,80(s1)
    800023d6:	64b8                	ld	a4,72(s1)
    800023d8:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800023da:	64bc                	ld	a5,72(s1)
    800023dc:	68b8                	ld	a4,80(s1)
    800023de:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800023e0:	00015797          	auipc	a5,0x15
    800023e4:	ab878793          	addi	a5,a5,-1352 # 80016e98 <bcache+0x8000>
    800023e8:	2b87b703          	ld	a4,696(a5)
    800023ec:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800023ee:	00015717          	auipc	a4,0x15
    800023f2:	d1270713          	addi	a4,a4,-750 # 80017100 <bcache+0x8268>
    800023f6:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800023f8:	2b87b703          	ld	a4,696(a5)
    800023fc:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800023fe:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002402:	0000d517          	auipc	a0,0xd
    80002406:	a9650513          	addi	a0,a0,-1386 # 8000ee98 <bcache>
    8000240a:	00004097          	auipc	ra,0x4
    8000240e:	cba080e7          	jalr	-838(ra) # 800060c4 <release>
}
    80002412:	60e2                	ld	ra,24(sp)
    80002414:	6442                	ld	s0,16(sp)
    80002416:	64a2                	ld	s1,8(sp)
    80002418:	6902                	ld	s2,0(sp)
    8000241a:	6105                	addi	sp,sp,32
    8000241c:	8082                	ret
    panic("brelse");
    8000241e:	00006517          	auipc	a0,0x6
    80002422:	08a50513          	addi	a0,a0,138 # 800084a8 <syscalls+0xe0>
    80002426:	00003097          	auipc	ra,0x3
    8000242a:	6ae080e7          	jalr	1710(ra) # 80005ad4 <panic>

000000008000242e <bpin>:

void
bpin(struct buf *b) {
    8000242e:	1101                	addi	sp,sp,-32
    80002430:	ec06                	sd	ra,24(sp)
    80002432:	e822                	sd	s0,16(sp)
    80002434:	e426                	sd	s1,8(sp)
    80002436:	1000                	addi	s0,sp,32
    80002438:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000243a:	0000d517          	auipc	a0,0xd
    8000243e:	a5e50513          	addi	a0,a0,-1442 # 8000ee98 <bcache>
    80002442:	00004097          	auipc	ra,0x4
    80002446:	bce080e7          	jalr	-1074(ra) # 80006010 <acquire>
  b->refcnt++;
    8000244a:	40bc                	lw	a5,64(s1)
    8000244c:	2785                	addiw	a5,a5,1
    8000244e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002450:	0000d517          	auipc	a0,0xd
    80002454:	a4850513          	addi	a0,a0,-1464 # 8000ee98 <bcache>
    80002458:	00004097          	auipc	ra,0x4
    8000245c:	c6c080e7          	jalr	-916(ra) # 800060c4 <release>
}
    80002460:	60e2                	ld	ra,24(sp)
    80002462:	6442                	ld	s0,16(sp)
    80002464:	64a2                	ld	s1,8(sp)
    80002466:	6105                	addi	sp,sp,32
    80002468:	8082                	ret

000000008000246a <bunpin>:

void
bunpin(struct buf *b) {
    8000246a:	1101                	addi	sp,sp,-32
    8000246c:	ec06                	sd	ra,24(sp)
    8000246e:	e822                	sd	s0,16(sp)
    80002470:	e426                	sd	s1,8(sp)
    80002472:	1000                	addi	s0,sp,32
    80002474:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002476:	0000d517          	auipc	a0,0xd
    8000247a:	a2250513          	addi	a0,a0,-1502 # 8000ee98 <bcache>
    8000247e:	00004097          	auipc	ra,0x4
    80002482:	b92080e7          	jalr	-1134(ra) # 80006010 <acquire>
  b->refcnt--;
    80002486:	40bc                	lw	a5,64(s1)
    80002488:	37fd                	addiw	a5,a5,-1
    8000248a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000248c:	0000d517          	auipc	a0,0xd
    80002490:	a0c50513          	addi	a0,a0,-1524 # 8000ee98 <bcache>
    80002494:	00004097          	auipc	ra,0x4
    80002498:	c30080e7          	jalr	-976(ra) # 800060c4 <release>
}
    8000249c:	60e2                	ld	ra,24(sp)
    8000249e:	6442                	ld	s0,16(sp)
    800024a0:	64a2                	ld	s1,8(sp)
    800024a2:	6105                	addi	sp,sp,32
    800024a4:	8082                	ret

00000000800024a6 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800024a6:	1101                	addi	sp,sp,-32
    800024a8:	ec06                	sd	ra,24(sp)
    800024aa:	e822                	sd	s0,16(sp)
    800024ac:	e426                	sd	s1,8(sp)
    800024ae:	e04a                	sd	s2,0(sp)
    800024b0:	1000                	addi	s0,sp,32
    800024b2:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800024b4:	00d5d59b          	srliw	a1,a1,0xd
    800024b8:	00015797          	auipc	a5,0x15
    800024bc:	0bc7a783          	lw	a5,188(a5) # 80017574 <sb+0x1c>
    800024c0:	9dbd                	addw	a1,a1,a5
    800024c2:	00000097          	auipc	ra,0x0
    800024c6:	d9e080e7          	jalr	-610(ra) # 80002260 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800024ca:	0074f713          	andi	a4,s1,7
    800024ce:	4785                	li	a5,1
    800024d0:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800024d4:	14ce                	slli	s1,s1,0x33
    800024d6:	90d9                	srli	s1,s1,0x36
    800024d8:	00950733          	add	a4,a0,s1
    800024dc:	05874703          	lbu	a4,88(a4)
    800024e0:	00e7f6b3          	and	a3,a5,a4
    800024e4:	c69d                	beqz	a3,80002512 <bfree+0x6c>
    800024e6:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800024e8:	94aa                	add	s1,s1,a0
    800024ea:	fff7c793          	not	a5,a5
    800024ee:	8ff9                	and	a5,a5,a4
    800024f0:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800024f4:	00001097          	auipc	ra,0x1
    800024f8:	118080e7          	jalr	280(ra) # 8000360c <log_write>
  brelse(bp);
    800024fc:	854a                	mv	a0,s2
    800024fe:	00000097          	auipc	ra,0x0
    80002502:	e92080e7          	jalr	-366(ra) # 80002390 <brelse>
}
    80002506:	60e2                	ld	ra,24(sp)
    80002508:	6442                	ld	s0,16(sp)
    8000250a:	64a2                	ld	s1,8(sp)
    8000250c:	6902                	ld	s2,0(sp)
    8000250e:	6105                	addi	sp,sp,32
    80002510:	8082                	ret
    panic("freeing free block");
    80002512:	00006517          	auipc	a0,0x6
    80002516:	f9e50513          	addi	a0,a0,-98 # 800084b0 <syscalls+0xe8>
    8000251a:	00003097          	auipc	ra,0x3
    8000251e:	5ba080e7          	jalr	1466(ra) # 80005ad4 <panic>

0000000080002522 <balloc>:
{
    80002522:	711d                	addi	sp,sp,-96
    80002524:	ec86                	sd	ra,88(sp)
    80002526:	e8a2                	sd	s0,80(sp)
    80002528:	e4a6                	sd	s1,72(sp)
    8000252a:	e0ca                	sd	s2,64(sp)
    8000252c:	fc4e                	sd	s3,56(sp)
    8000252e:	f852                	sd	s4,48(sp)
    80002530:	f456                	sd	s5,40(sp)
    80002532:	f05a                	sd	s6,32(sp)
    80002534:	ec5e                	sd	s7,24(sp)
    80002536:	e862                	sd	s8,16(sp)
    80002538:	e466                	sd	s9,8(sp)
    8000253a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000253c:	00015797          	auipc	a5,0x15
    80002540:	0207a783          	lw	a5,32(a5) # 8001755c <sb+0x4>
    80002544:	cbd1                	beqz	a5,800025d8 <balloc+0xb6>
    80002546:	8baa                	mv	s7,a0
    80002548:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000254a:	00015b17          	auipc	s6,0x15
    8000254e:	00eb0b13          	addi	s6,s6,14 # 80017558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002552:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002554:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002556:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002558:	6c89                	lui	s9,0x2
    8000255a:	a831                	j	80002576 <balloc+0x54>
    brelse(bp);
    8000255c:	854a                	mv	a0,s2
    8000255e:	00000097          	auipc	ra,0x0
    80002562:	e32080e7          	jalr	-462(ra) # 80002390 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002566:	015c87bb          	addw	a5,s9,s5
    8000256a:	00078a9b          	sext.w	s5,a5
    8000256e:	004b2703          	lw	a4,4(s6)
    80002572:	06eaf363          	bgeu	s5,a4,800025d8 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80002576:	41fad79b          	sraiw	a5,s5,0x1f
    8000257a:	0137d79b          	srliw	a5,a5,0x13
    8000257e:	015787bb          	addw	a5,a5,s5
    80002582:	40d7d79b          	sraiw	a5,a5,0xd
    80002586:	01cb2583          	lw	a1,28(s6)
    8000258a:	9dbd                	addw	a1,a1,a5
    8000258c:	855e                	mv	a0,s7
    8000258e:	00000097          	auipc	ra,0x0
    80002592:	cd2080e7          	jalr	-814(ra) # 80002260 <bread>
    80002596:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002598:	004b2503          	lw	a0,4(s6)
    8000259c:	000a849b          	sext.w	s1,s5
    800025a0:	8662                	mv	a2,s8
    800025a2:	faa4fde3          	bgeu	s1,a0,8000255c <balloc+0x3a>
      m = 1 << (bi % 8);
    800025a6:	41f6579b          	sraiw	a5,a2,0x1f
    800025aa:	01d7d69b          	srliw	a3,a5,0x1d
    800025ae:	00c6873b          	addw	a4,a3,a2
    800025b2:	00777793          	andi	a5,a4,7
    800025b6:	9f95                	subw	a5,a5,a3
    800025b8:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800025bc:	4037571b          	sraiw	a4,a4,0x3
    800025c0:	00e906b3          	add	a3,s2,a4
    800025c4:	0586c683          	lbu	a3,88(a3)
    800025c8:	00d7f5b3          	and	a1,a5,a3
    800025cc:	cd91                	beqz	a1,800025e8 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025ce:	2605                	addiw	a2,a2,1
    800025d0:	2485                	addiw	s1,s1,1
    800025d2:	fd4618e3          	bne	a2,s4,800025a2 <balloc+0x80>
    800025d6:	b759                	j	8000255c <balloc+0x3a>
  panic("balloc: out of blocks");
    800025d8:	00006517          	auipc	a0,0x6
    800025dc:	ef050513          	addi	a0,a0,-272 # 800084c8 <syscalls+0x100>
    800025e0:	00003097          	auipc	ra,0x3
    800025e4:	4f4080e7          	jalr	1268(ra) # 80005ad4 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800025e8:	974a                	add	a4,a4,s2
    800025ea:	8fd5                	or	a5,a5,a3
    800025ec:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800025f0:	854a                	mv	a0,s2
    800025f2:	00001097          	auipc	ra,0x1
    800025f6:	01a080e7          	jalr	26(ra) # 8000360c <log_write>
        brelse(bp);
    800025fa:	854a                	mv	a0,s2
    800025fc:	00000097          	auipc	ra,0x0
    80002600:	d94080e7          	jalr	-620(ra) # 80002390 <brelse>
  bp = bread(dev, bno);
    80002604:	85a6                	mv	a1,s1
    80002606:	855e                	mv	a0,s7
    80002608:	00000097          	auipc	ra,0x0
    8000260c:	c58080e7          	jalr	-936(ra) # 80002260 <bread>
    80002610:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002612:	40000613          	li	a2,1024
    80002616:	4581                	li	a1,0
    80002618:	05850513          	addi	a0,a0,88
    8000261c:	ffffe097          	auipc	ra,0xffffe
    80002620:	b5c080e7          	jalr	-1188(ra) # 80000178 <memset>
  log_write(bp);
    80002624:	854a                	mv	a0,s2
    80002626:	00001097          	auipc	ra,0x1
    8000262a:	fe6080e7          	jalr	-26(ra) # 8000360c <log_write>
  brelse(bp);
    8000262e:	854a                	mv	a0,s2
    80002630:	00000097          	auipc	ra,0x0
    80002634:	d60080e7          	jalr	-672(ra) # 80002390 <brelse>
}
    80002638:	8526                	mv	a0,s1
    8000263a:	60e6                	ld	ra,88(sp)
    8000263c:	6446                	ld	s0,80(sp)
    8000263e:	64a6                	ld	s1,72(sp)
    80002640:	6906                	ld	s2,64(sp)
    80002642:	79e2                	ld	s3,56(sp)
    80002644:	7a42                	ld	s4,48(sp)
    80002646:	7aa2                	ld	s5,40(sp)
    80002648:	7b02                	ld	s6,32(sp)
    8000264a:	6be2                	ld	s7,24(sp)
    8000264c:	6c42                	ld	s8,16(sp)
    8000264e:	6ca2                	ld	s9,8(sp)
    80002650:	6125                	addi	sp,sp,96
    80002652:	8082                	ret

0000000080002654 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002654:	7179                	addi	sp,sp,-48
    80002656:	f406                	sd	ra,40(sp)
    80002658:	f022                	sd	s0,32(sp)
    8000265a:	ec26                	sd	s1,24(sp)
    8000265c:	e84a                	sd	s2,16(sp)
    8000265e:	e44e                	sd	s3,8(sp)
    80002660:	e052                	sd	s4,0(sp)
    80002662:	1800                	addi	s0,sp,48
    80002664:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002666:	47ad                	li	a5,11
    80002668:	04b7fe63          	bgeu	a5,a1,800026c4 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000266c:	ff45849b          	addiw	s1,a1,-12
    80002670:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002674:	0ff00793          	li	a5,255
    80002678:	0ae7e363          	bltu	a5,a4,8000271e <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000267c:	08052583          	lw	a1,128(a0)
    80002680:	c5ad                	beqz	a1,800026ea <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002682:	00092503          	lw	a0,0(s2)
    80002686:	00000097          	auipc	ra,0x0
    8000268a:	bda080e7          	jalr	-1062(ra) # 80002260 <bread>
    8000268e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002690:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002694:	02049593          	slli	a1,s1,0x20
    80002698:	9181                	srli	a1,a1,0x20
    8000269a:	058a                	slli	a1,a1,0x2
    8000269c:	00b784b3          	add	s1,a5,a1
    800026a0:	0004a983          	lw	s3,0(s1)
    800026a4:	04098d63          	beqz	s3,800026fe <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800026a8:	8552                	mv	a0,s4
    800026aa:	00000097          	auipc	ra,0x0
    800026ae:	ce6080e7          	jalr	-794(ra) # 80002390 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800026b2:	854e                	mv	a0,s3
    800026b4:	70a2                	ld	ra,40(sp)
    800026b6:	7402                	ld	s0,32(sp)
    800026b8:	64e2                	ld	s1,24(sp)
    800026ba:	6942                	ld	s2,16(sp)
    800026bc:	69a2                	ld	s3,8(sp)
    800026be:	6a02                	ld	s4,0(sp)
    800026c0:	6145                	addi	sp,sp,48
    800026c2:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800026c4:	02059493          	slli	s1,a1,0x20
    800026c8:	9081                	srli	s1,s1,0x20
    800026ca:	048a                	slli	s1,s1,0x2
    800026cc:	94aa                	add	s1,s1,a0
    800026ce:	0504a983          	lw	s3,80(s1)
    800026d2:	fe0990e3          	bnez	s3,800026b2 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800026d6:	4108                	lw	a0,0(a0)
    800026d8:	00000097          	auipc	ra,0x0
    800026dc:	e4a080e7          	jalr	-438(ra) # 80002522 <balloc>
    800026e0:	0005099b          	sext.w	s3,a0
    800026e4:	0534a823          	sw	s3,80(s1)
    800026e8:	b7e9                	j	800026b2 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800026ea:	4108                	lw	a0,0(a0)
    800026ec:	00000097          	auipc	ra,0x0
    800026f0:	e36080e7          	jalr	-458(ra) # 80002522 <balloc>
    800026f4:	0005059b          	sext.w	a1,a0
    800026f8:	08b92023          	sw	a1,128(s2)
    800026fc:	b759                	j	80002682 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800026fe:	00092503          	lw	a0,0(s2)
    80002702:	00000097          	auipc	ra,0x0
    80002706:	e20080e7          	jalr	-480(ra) # 80002522 <balloc>
    8000270a:	0005099b          	sext.w	s3,a0
    8000270e:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002712:	8552                	mv	a0,s4
    80002714:	00001097          	auipc	ra,0x1
    80002718:	ef8080e7          	jalr	-264(ra) # 8000360c <log_write>
    8000271c:	b771                	j	800026a8 <bmap+0x54>
  panic("bmap: out of range");
    8000271e:	00006517          	auipc	a0,0x6
    80002722:	dc250513          	addi	a0,a0,-574 # 800084e0 <syscalls+0x118>
    80002726:	00003097          	auipc	ra,0x3
    8000272a:	3ae080e7          	jalr	942(ra) # 80005ad4 <panic>

000000008000272e <iget>:
{
    8000272e:	7179                	addi	sp,sp,-48
    80002730:	f406                	sd	ra,40(sp)
    80002732:	f022                	sd	s0,32(sp)
    80002734:	ec26                	sd	s1,24(sp)
    80002736:	e84a                	sd	s2,16(sp)
    80002738:	e44e                	sd	s3,8(sp)
    8000273a:	e052                	sd	s4,0(sp)
    8000273c:	1800                	addi	s0,sp,48
    8000273e:	89aa                	mv	s3,a0
    80002740:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002742:	00015517          	auipc	a0,0x15
    80002746:	e3650513          	addi	a0,a0,-458 # 80017578 <itable>
    8000274a:	00004097          	auipc	ra,0x4
    8000274e:	8c6080e7          	jalr	-1850(ra) # 80006010 <acquire>
  empty = 0;
    80002752:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002754:	00015497          	auipc	s1,0x15
    80002758:	e3c48493          	addi	s1,s1,-452 # 80017590 <itable+0x18>
    8000275c:	00017697          	auipc	a3,0x17
    80002760:	8c468693          	addi	a3,a3,-1852 # 80019020 <log>
    80002764:	a039                	j	80002772 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002766:	02090b63          	beqz	s2,8000279c <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000276a:	08848493          	addi	s1,s1,136
    8000276e:	02d48a63          	beq	s1,a3,800027a2 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002772:	449c                	lw	a5,8(s1)
    80002774:	fef059e3          	blez	a5,80002766 <iget+0x38>
    80002778:	4098                	lw	a4,0(s1)
    8000277a:	ff3716e3          	bne	a4,s3,80002766 <iget+0x38>
    8000277e:	40d8                	lw	a4,4(s1)
    80002780:	ff4713e3          	bne	a4,s4,80002766 <iget+0x38>
      ip->ref++;
    80002784:	2785                	addiw	a5,a5,1
    80002786:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002788:	00015517          	auipc	a0,0x15
    8000278c:	df050513          	addi	a0,a0,-528 # 80017578 <itable>
    80002790:	00004097          	auipc	ra,0x4
    80002794:	934080e7          	jalr	-1740(ra) # 800060c4 <release>
      return ip;
    80002798:	8926                	mv	s2,s1
    8000279a:	a03d                	j	800027c8 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000279c:	f7f9                	bnez	a5,8000276a <iget+0x3c>
    8000279e:	8926                	mv	s2,s1
    800027a0:	b7e9                	j	8000276a <iget+0x3c>
  if(empty == 0)
    800027a2:	02090c63          	beqz	s2,800027da <iget+0xac>
  ip->dev = dev;
    800027a6:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800027aa:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800027ae:	4785                	li	a5,1
    800027b0:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800027b4:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800027b8:	00015517          	auipc	a0,0x15
    800027bc:	dc050513          	addi	a0,a0,-576 # 80017578 <itable>
    800027c0:	00004097          	auipc	ra,0x4
    800027c4:	904080e7          	jalr	-1788(ra) # 800060c4 <release>
}
    800027c8:	854a                	mv	a0,s2
    800027ca:	70a2                	ld	ra,40(sp)
    800027cc:	7402                	ld	s0,32(sp)
    800027ce:	64e2                	ld	s1,24(sp)
    800027d0:	6942                	ld	s2,16(sp)
    800027d2:	69a2                	ld	s3,8(sp)
    800027d4:	6a02                	ld	s4,0(sp)
    800027d6:	6145                	addi	sp,sp,48
    800027d8:	8082                	ret
    panic("iget: no inodes");
    800027da:	00006517          	auipc	a0,0x6
    800027de:	d1e50513          	addi	a0,a0,-738 # 800084f8 <syscalls+0x130>
    800027e2:	00003097          	auipc	ra,0x3
    800027e6:	2f2080e7          	jalr	754(ra) # 80005ad4 <panic>

00000000800027ea <fsinit>:
fsinit(int dev) {
    800027ea:	7179                	addi	sp,sp,-48
    800027ec:	f406                	sd	ra,40(sp)
    800027ee:	f022                	sd	s0,32(sp)
    800027f0:	ec26                	sd	s1,24(sp)
    800027f2:	e84a                	sd	s2,16(sp)
    800027f4:	e44e                	sd	s3,8(sp)
    800027f6:	1800                	addi	s0,sp,48
    800027f8:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800027fa:	4585                	li	a1,1
    800027fc:	00000097          	auipc	ra,0x0
    80002800:	a64080e7          	jalr	-1436(ra) # 80002260 <bread>
    80002804:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002806:	00015997          	auipc	s3,0x15
    8000280a:	d5298993          	addi	s3,s3,-686 # 80017558 <sb>
    8000280e:	02000613          	li	a2,32
    80002812:	05850593          	addi	a1,a0,88
    80002816:	854e                	mv	a0,s3
    80002818:	ffffe097          	auipc	ra,0xffffe
    8000281c:	9bc080e7          	jalr	-1604(ra) # 800001d4 <memmove>
  brelse(bp);
    80002820:	8526                	mv	a0,s1
    80002822:	00000097          	auipc	ra,0x0
    80002826:	b6e080e7          	jalr	-1170(ra) # 80002390 <brelse>
  if(sb.magic != FSMAGIC)
    8000282a:	0009a703          	lw	a4,0(s3)
    8000282e:	102037b7          	lui	a5,0x10203
    80002832:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002836:	02f71263          	bne	a4,a5,8000285a <fsinit+0x70>
  initlog(dev, &sb);
    8000283a:	00015597          	auipc	a1,0x15
    8000283e:	d1e58593          	addi	a1,a1,-738 # 80017558 <sb>
    80002842:	854a                	mv	a0,s2
    80002844:	00001097          	auipc	ra,0x1
    80002848:	b4c080e7          	jalr	-1204(ra) # 80003390 <initlog>
}
    8000284c:	70a2                	ld	ra,40(sp)
    8000284e:	7402                	ld	s0,32(sp)
    80002850:	64e2                	ld	s1,24(sp)
    80002852:	6942                	ld	s2,16(sp)
    80002854:	69a2                	ld	s3,8(sp)
    80002856:	6145                	addi	sp,sp,48
    80002858:	8082                	ret
    panic("invalid file system");
    8000285a:	00006517          	auipc	a0,0x6
    8000285e:	cae50513          	addi	a0,a0,-850 # 80008508 <syscalls+0x140>
    80002862:	00003097          	auipc	ra,0x3
    80002866:	272080e7          	jalr	626(ra) # 80005ad4 <panic>

000000008000286a <iinit>:
{
    8000286a:	7179                	addi	sp,sp,-48
    8000286c:	f406                	sd	ra,40(sp)
    8000286e:	f022                	sd	s0,32(sp)
    80002870:	ec26                	sd	s1,24(sp)
    80002872:	e84a                	sd	s2,16(sp)
    80002874:	e44e                	sd	s3,8(sp)
    80002876:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002878:	00006597          	auipc	a1,0x6
    8000287c:	ca858593          	addi	a1,a1,-856 # 80008520 <syscalls+0x158>
    80002880:	00015517          	auipc	a0,0x15
    80002884:	cf850513          	addi	a0,a0,-776 # 80017578 <itable>
    80002888:	00003097          	auipc	ra,0x3
    8000288c:	6f8080e7          	jalr	1784(ra) # 80005f80 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002890:	00015497          	auipc	s1,0x15
    80002894:	d1048493          	addi	s1,s1,-752 # 800175a0 <itable+0x28>
    80002898:	00016997          	auipc	s3,0x16
    8000289c:	79898993          	addi	s3,s3,1944 # 80019030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800028a0:	00006917          	auipc	s2,0x6
    800028a4:	c8890913          	addi	s2,s2,-888 # 80008528 <syscalls+0x160>
    800028a8:	85ca                	mv	a1,s2
    800028aa:	8526                	mv	a0,s1
    800028ac:	00001097          	auipc	ra,0x1
    800028b0:	e46080e7          	jalr	-442(ra) # 800036f2 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800028b4:	08848493          	addi	s1,s1,136
    800028b8:	ff3498e3          	bne	s1,s3,800028a8 <iinit+0x3e>
}
    800028bc:	70a2                	ld	ra,40(sp)
    800028be:	7402                	ld	s0,32(sp)
    800028c0:	64e2                	ld	s1,24(sp)
    800028c2:	6942                	ld	s2,16(sp)
    800028c4:	69a2                	ld	s3,8(sp)
    800028c6:	6145                	addi	sp,sp,48
    800028c8:	8082                	ret

00000000800028ca <ialloc>:
{
    800028ca:	715d                	addi	sp,sp,-80
    800028cc:	e486                	sd	ra,72(sp)
    800028ce:	e0a2                	sd	s0,64(sp)
    800028d0:	fc26                	sd	s1,56(sp)
    800028d2:	f84a                	sd	s2,48(sp)
    800028d4:	f44e                	sd	s3,40(sp)
    800028d6:	f052                	sd	s4,32(sp)
    800028d8:	ec56                	sd	s5,24(sp)
    800028da:	e85a                	sd	s6,16(sp)
    800028dc:	e45e                	sd	s7,8(sp)
    800028de:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800028e0:	00015717          	auipc	a4,0x15
    800028e4:	c8472703          	lw	a4,-892(a4) # 80017564 <sb+0xc>
    800028e8:	4785                	li	a5,1
    800028ea:	04e7fa63          	bgeu	a5,a4,8000293e <ialloc+0x74>
    800028ee:	8aaa                	mv	s5,a0
    800028f0:	8bae                	mv	s7,a1
    800028f2:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800028f4:	00015a17          	auipc	s4,0x15
    800028f8:	c64a0a13          	addi	s4,s4,-924 # 80017558 <sb>
    800028fc:	00048b1b          	sext.w	s6,s1
    80002900:	0044d793          	srli	a5,s1,0x4
    80002904:	018a2583          	lw	a1,24(s4)
    80002908:	9dbd                	addw	a1,a1,a5
    8000290a:	8556                	mv	a0,s5
    8000290c:	00000097          	auipc	ra,0x0
    80002910:	954080e7          	jalr	-1708(ra) # 80002260 <bread>
    80002914:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002916:	05850993          	addi	s3,a0,88
    8000291a:	00f4f793          	andi	a5,s1,15
    8000291e:	079a                	slli	a5,a5,0x6
    80002920:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002922:	00099783          	lh	a5,0(s3)
    80002926:	c785                	beqz	a5,8000294e <ialloc+0x84>
    brelse(bp);
    80002928:	00000097          	auipc	ra,0x0
    8000292c:	a68080e7          	jalr	-1432(ra) # 80002390 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002930:	0485                	addi	s1,s1,1
    80002932:	00ca2703          	lw	a4,12(s4)
    80002936:	0004879b          	sext.w	a5,s1
    8000293a:	fce7e1e3          	bltu	a5,a4,800028fc <ialloc+0x32>
  panic("ialloc: no inodes");
    8000293e:	00006517          	auipc	a0,0x6
    80002942:	bf250513          	addi	a0,a0,-1038 # 80008530 <syscalls+0x168>
    80002946:	00003097          	auipc	ra,0x3
    8000294a:	18e080e7          	jalr	398(ra) # 80005ad4 <panic>
      memset(dip, 0, sizeof(*dip));
    8000294e:	04000613          	li	a2,64
    80002952:	4581                	li	a1,0
    80002954:	854e                	mv	a0,s3
    80002956:	ffffe097          	auipc	ra,0xffffe
    8000295a:	822080e7          	jalr	-2014(ra) # 80000178 <memset>
      dip->type = type;
    8000295e:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002962:	854a                	mv	a0,s2
    80002964:	00001097          	auipc	ra,0x1
    80002968:	ca8080e7          	jalr	-856(ra) # 8000360c <log_write>
      brelse(bp);
    8000296c:	854a                	mv	a0,s2
    8000296e:	00000097          	auipc	ra,0x0
    80002972:	a22080e7          	jalr	-1502(ra) # 80002390 <brelse>
      return iget(dev, inum);
    80002976:	85da                	mv	a1,s6
    80002978:	8556                	mv	a0,s5
    8000297a:	00000097          	auipc	ra,0x0
    8000297e:	db4080e7          	jalr	-588(ra) # 8000272e <iget>
}
    80002982:	60a6                	ld	ra,72(sp)
    80002984:	6406                	ld	s0,64(sp)
    80002986:	74e2                	ld	s1,56(sp)
    80002988:	7942                	ld	s2,48(sp)
    8000298a:	79a2                	ld	s3,40(sp)
    8000298c:	7a02                	ld	s4,32(sp)
    8000298e:	6ae2                	ld	s5,24(sp)
    80002990:	6b42                	ld	s6,16(sp)
    80002992:	6ba2                	ld	s7,8(sp)
    80002994:	6161                	addi	sp,sp,80
    80002996:	8082                	ret

0000000080002998 <iupdate>:
{
    80002998:	1101                	addi	sp,sp,-32
    8000299a:	ec06                	sd	ra,24(sp)
    8000299c:	e822                	sd	s0,16(sp)
    8000299e:	e426                	sd	s1,8(sp)
    800029a0:	e04a                	sd	s2,0(sp)
    800029a2:	1000                	addi	s0,sp,32
    800029a4:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800029a6:	415c                	lw	a5,4(a0)
    800029a8:	0047d79b          	srliw	a5,a5,0x4
    800029ac:	00015597          	auipc	a1,0x15
    800029b0:	bc45a583          	lw	a1,-1084(a1) # 80017570 <sb+0x18>
    800029b4:	9dbd                	addw	a1,a1,a5
    800029b6:	4108                	lw	a0,0(a0)
    800029b8:	00000097          	auipc	ra,0x0
    800029bc:	8a8080e7          	jalr	-1880(ra) # 80002260 <bread>
    800029c0:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800029c2:	05850793          	addi	a5,a0,88
    800029c6:	40c8                	lw	a0,4(s1)
    800029c8:	893d                	andi	a0,a0,15
    800029ca:	051a                	slli	a0,a0,0x6
    800029cc:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    800029ce:	04449703          	lh	a4,68(s1)
    800029d2:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    800029d6:	04649703          	lh	a4,70(s1)
    800029da:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    800029de:	04849703          	lh	a4,72(s1)
    800029e2:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    800029e6:	04a49703          	lh	a4,74(s1)
    800029ea:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    800029ee:	44f8                	lw	a4,76(s1)
    800029f0:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800029f2:	03400613          	li	a2,52
    800029f6:	05048593          	addi	a1,s1,80
    800029fa:	0531                	addi	a0,a0,12
    800029fc:	ffffd097          	auipc	ra,0xffffd
    80002a00:	7d8080e7          	jalr	2008(ra) # 800001d4 <memmove>
  log_write(bp);
    80002a04:	854a                	mv	a0,s2
    80002a06:	00001097          	auipc	ra,0x1
    80002a0a:	c06080e7          	jalr	-1018(ra) # 8000360c <log_write>
  brelse(bp);
    80002a0e:	854a                	mv	a0,s2
    80002a10:	00000097          	auipc	ra,0x0
    80002a14:	980080e7          	jalr	-1664(ra) # 80002390 <brelse>
}
    80002a18:	60e2                	ld	ra,24(sp)
    80002a1a:	6442                	ld	s0,16(sp)
    80002a1c:	64a2                	ld	s1,8(sp)
    80002a1e:	6902                	ld	s2,0(sp)
    80002a20:	6105                	addi	sp,sp,32
    80002a22:	8082                	ret

0000000080002a24 <idup>:
{
    80002a24:	1101                	addi	sp,sp,-32
    80002a26:	ec06                	sd	ra,24(sp)
    80002a28:	e822                	sd	s0,16(sp)
    80002a2a:	e426                	sd	s1,8(sp)
    80002a2c:	1000                	addi	s0,sp,32
    80002a2e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002a30:	00015517          	auipc	a0,0x15
    80002a34:	b4850513          	addi	a0,a0,-1208 # 80017578 <itable>
    80002a38:	00003097          	auipc	ra,0x3
    80002a3c:	5d8080e7          	jalr	1496(ra) # 80006010 <acquire>
  ip->ref++;
    80002a40:	449c                	lw	a5,8(s1)
    80002a42:	2785                	addiw	a5,a5,1
    80002a44:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002a46:	00015517          	auipc	a0,0x15
    80002a4a:	b3250513          	addi	a0,a0,-1230 # 80017578 <itable>
    80002a4e:	00003097          	auipc	ra,0x3
    80002a52:	676080e7          	jalr	1654(ra) # 800060c4 <release>
}
    80002a56:	8526                	mv	a0,s1
    80002a58:	60e2                	ld	ra,24(sp)
    80002a5a:	6442                	ld	s0,16(sp)
    80002a5c:	64a2                	ld	s1,8(sp)
    80002a5e:	6105                	addi	sp,sp,32
    80002a60:	8082                	ret

0000000080002a62 <ilock>:
{
    80002a62:	1101                	addi	sp,sp,-32
    80002a64:	ec06                	sd	ra,24(sp)
    80002a66:	e822                	sd	s0,16(sp)
    80002a68:	e426                	sd	s1,8(sp)
    80002a6a:	e04a                	sd	s2,0(sp)
    80002a6c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002a6e:	c115                	beqz	a0,80002a92 <ilock+0x30>
    80002a70:	84aa                	mv	s1,a0
    80002a72:	451c                	lw	a5,8(a0)
    80002a74:	00f05f63          	blez	a5,80002a92 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002a78:	0541                	addi	a0,a0,16
    80002a7a:	00001097          	auipc	ra,0x1
    80002a7e:	cb2080e7          	jalr	-846(ra) # 8000372c <acquiresleep>
  if(ip->valid == 0){
    80002a82:	40bc                	lw	a5,64(s1)
    80002a84:	cf99                	beqz	a5,80002aa2 <ilock+0x40>
}
    80002a86:	60e2                	ld	ra,24(sp)
    80002a88:	6442                	ld	s0,16(sp)
    80002a8a:	64a2                	ld	s1,8(sp)
    80002a8c:	6902                	ld	s2,0(sp)
    80002a8e:	6105                	addi	sp,sp,32
    80002a90:	8082                	ret
    panic("ilock");
    80002a92:	00006517          	auipc	a0,0x6
    80002a96:	ab650513          	addi	a0,a0,-1354 # 80008548 <syscalls+0x180>
    80002a9a:	00003097          	auipc	ra,0x3
    80002a9e:	03a080e7          	jalr	58(ra) # 80005ad4 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002aa2:	40dc                	lw	a5,4(s1)
    80002aa4:	0047d79b          	srliw	a5,a5,0x4
    80002aa8:	00015597          	auipc	a1,0x15
    80002aac:	ac85a583          	lw	a1,-1336(a1) # 80017570 <sb+0x18>
    80002ab0:	9dbd                	addw	a1,a1,a5
    80002ab2:	4088                	lw	a0,0(s1)
    80002ab4:	fffff097          	auipc	ra,0xfffff
    80002ab8:	7ac080e7          	jalr	1964(ra) # 80002260 <bread>
    80002abc:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002abe:	05850593          	addi	a1,a0,88
    80002ac2:	40dc                	lw	a5,4(s1)
    80002ac4:	8bbd                	andi	a5,a5,15
    80002ac6:	079a                	slli	a5,a5,0x6
    80002ac8:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002aca:	00059783          	lh	a5,0(a1)
    80002ace:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002ad2:	00259783          	lh	a5,2(a1)
    80002ad6:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002ada:	00459783          	lh	a5,4(a1)
    80002ade:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002ae2:	00659783          	lh	a5,6(a1)
    80002ae6:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002aea:	459c                	lw	a5,8(a1)
    80002aec:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002aee:	03400613          	li	a2,52
    80002af2:	05b1                	addi	a1,a1,12
    80002af4:	05048513          	addi	a0,s1,80
    80002af8:	ffffd097          	auipc	ra,0xffffd
    80002afc:	6dc080e7          	jalr	1756(ra) # 800001d4 <memmove>
    brelse(bp);
    80002b00:	854a                	mv	a0,s2
    80002b02:	00000097          	auipc	ra,0x0
    80002b06:	88e080e7          	jalr	-1906(ra) # 80002390 <brelse>
    ip->valid = 1;
    80002b0a:	4785                	li	a5,1
    80002b0c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002b0e:	04449783          	lh	a5,68(s1)
    80002b12:	fbb5                	bnez	a5,80002a86 <ilock+0x24>
      panic("ilock: no type");
    80002b14:	00006517          	auipc	a0,0x6
    80002b18:	a3c50513          	addi	a0,a0,-1476 # 80008550 <syscalls+0x188>
    80002b1c:	00003097          	auipc	ra,0x3
    80002b20:	fb8080e7          	jalr	-72(ra) # 80005ad4 <panic>

0000000080002b24 <iunlock>:
{
    80002b24:	1101                	addi	sp,sp,-32
    80002b26:	ec06                	sd	ra,24(sp)
    80002b28:	e822                	sd	s0,16(sp)
    80002b2a:	e426                	sd	s1,8(sp)
    80002b2c:	e04a                	sd	s2,0(sp)
    80002b2e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002b30:	c905                	beqz	a0,80002b60 <iunlock+0x3c>
    80002b32:	84aa                	mv	s1,a0
    80002b34:	01050913          	addi	s2,a0,16
    80002b38:	854a                	mv	a0,s2
    80002b3a:	00001097          	auipc	ra,0x1
    80002b3e:	c8c080e7          	jalr	-884(ra) # 800037c6 <holdingsleep>
    80002b42:	cd19                	beqz	a0,80002b60 <iunlock+0x3c>
    80002b44:	449c                	lw	a5,8(s1)
    80002b46:	00f05d63          	blez	a5,80002b60 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002b4a:	854a                	mv	a0,s2
    80002b4c:	00001097          	auipc	ra,0x1
    80002b50:	c36080e7          	jalr	-970(ra) # 80003782 <releasesleep>
}
    80002b54:	60e2                	ld	ra,24(sp)
    80002b56:	6442                	ld	s0,16(sp)
    80002b58:	64a2                	ld	s1,8(sp)
    80002b5a:	6902                	ld	s2,0(sp)
    80002b5c:	6105                	addi	sp,sp,32
    80002b5e:	8082                	ret
    panic("iunlock");
    80002b60:	00006517          	auipc	a0,0x6
    80002b64:	a0050513          	addi	a0,a0,-1536 # 80008560 <syscalls+0x198>
    80002b68:	00003097          	auipc	ra,0x3
    80002b6c:	f6c080e7          	jalr	-148(ra) # 80005ad4 <panic>

0000000080002b70 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002b70:	7179                	addi	sp,sp,-48
    80002b72:	f406                	sd	ra,40(sp)
    80002b74:	f022                	sd	s0,32(sp)
    80002b76:	ec26                	sd	s1,24(sp)
    80002b78:	e84a                	sd	s2,16(sp)
    80002b7a:	e44e                	sd	s3,8(sp)
    80002b7c:	e052                	sd	s4,0(sp)
    80002b7e:	1800                	addi	s0,sp,48
    80002b80:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002b82:	05050493          	addi	s1,a0,80
    80002b86:	08050913          	addi	s2,a0,128
    80002b8a:	a021                	j	80002b92 <itrunc+0x22>
    80002b8c:	0491                	addi	s1,s1,4
    80002b8e:	01248d63          	beq	s1,s2,80002ba8 <itrunc+0x38>
    if(ip->addrs[i]){
    80002b92:	408c                	lw	a1,0(s1)
    80002b94:	dde5                	beqz	a1,80002b8c <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002b96:	0009a503          	lw	a0,0(s3)
    80002b9a:	00000097          	auipc	ra,0x0
    80002b9e:	90c080e7          	jalr	-1780(ra) # 800024a6 <bfree>
      ip->addrs[i] = 0;
    80002ba2:	0004a023          	sw	zero,0(s1)
    80002ba6:	b7dd                	j	80002b8c <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002ba8:	0809a583          	lw	a1,128(s3)
    80002bac:	e185                	bnez	a1,80002bcc <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002bae:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002bb2:	854e                	mv	a0,s3
    80002bb4:	00000097          	auipc	ra,0x0
    80002bb8:	de4080e7          	jalr	-540(ra) # 80002998 <iupdate>
}
    80002bbc:	70a2                	ld	ra,40(sp)
    80002bbe:	7402                	ld	s0,32(sp)
    80002bc0:	64e2                	ld	s1,24(sp)
    80002bc2:	6942                	ld	s2,16(sp)
    80002bc4:	69a2                	ld	s3,8(sp)
    80002bc6:	6a02                	ld	s4,0(sp)
    80002bc8:	6145                	addi	sp,sp,48
    80002bca:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002bcc:	0009a503          	lw	a0,0(s3)
    80002bd0:	fffff097          	auipc	ra,0xfffff
    80002bd4:	690080e7          	jalr	1680(ra) # 80002260 <bread>
    80002bd8:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002bda:	05850493          	addi	s1,a0,88
    80002bde:	45850913          	addi	s2,a0,1112
    80002be2:	a021                	j	80002bea <itrunc+0x7a>
    80002be4:	0491                	addi	s1,s1,4
    80002be6:	01248b63          	beq	s1,s2,80002bfc <itrunc+0x8c>
      if(a[j])
    80002bea:	408c                	lw	a1,0(s1)
    80002bec:	dde5                	beqz	a1,80002be4 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002bee:	0009a503          	lw	a0,0(s3)
    80002bf2:	00000097          	auipc	ra,0x0
    80002bf6:	8b4080e7          	jalr	-1868(ra) # 800024a6 <bfree>
    80002bfa:	b7ed                	j	80002be4 <itrunc+0x74>
    brelse(bp);
    80002bfc:	8552                	mv	a0,s4
    80002bfe:	fffff097          	auipc	ra,0xfffff
    80002c02:	792080e7          	jalr	1938(ra) # 80002390 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002c06:	0809a583          	lw	a1,128(s3)
    80002c0a:	0009a503          	lw	a0,0(s3)
    80002c0e:	00000097          	auipc	ra,0x0
    80002c12:	898080e7          	jalr	-1896(ra) # 800024a6 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002c16:	0809a023          	sw	zero,128(s3)
    80002c1a:	bf51                	j	80002bae <itrunc+0x3e>

0000000080002c1c <iput>:
{
    80002c1c:	1101                	addi	sp,sp,-32
    80002c1e:	ec06                	sd	ra,24(sp)
    80002c20:	e822                	sd	s0,16(sp)
    80002c22:	e426                	sd	s1,8(sp)
    80002c24:	e04a                	sd	s2,0(sp)
    80002c26:	1000                	addi	s0,sp,32
    80002c28:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c2a:	00015517          	auipc	a0,0x15
    80002c2e:	94e50513          	addi	a0,a0,-1714 # 80017578 <itable>
    80002c32:	00003097          	auipc	ra,0x3
    80002c36:	3de080e7          	jalr	990(ra) # 80006010 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002c3a:	4498                	lw	a4,8(s1)
    80002c3c:	4785                	li	a5,1
    80002c3e:	02f70363          	beq	a4,a5,80002c64 <iput+0x48>
  ip->ref--;
    80002c42:	449c                	lw	a5,8(s1)
    80002c44:	37fd                	addiw	a5,a5,-1
    80002c46:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c48:	00015517          	auipc	a0,0x15
    80002c4c:	93050513          	addi	a0,a0,-1744 # 80017578 <itable>
    80002c50:	00003097          	auipc	ra,0x3
    80002c54:	474080e7          	jalr	1140(ra) # 800060c4 <release>
}
    80002c58:	60e2                	ld	ra,24(sp)
    80002c5a:	6442                	ld	s0,16(sp)
    80002c5c:	64a2                	ld	s1,8(sp)
    80002c5e:	6902                	ld	s2,0(sp)
    80002c60:	6105                	addi	sp,sp,32
    80002c62:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002c64:	40bc                	lw	a5,64(s1)
    80002c66:	dff1                	beqz	a5,80002c42 <iput+0x26>
    80002c68:	04a49783          	lh	a5,74(s1)
    80002c6c:	fbf9                	bnez	a5,80002c42 <iput+0x26>
    acquiresleep(&ip->lock);
    80002c6e:	01048913          	addi	s2,s1,16
    80002c72:	854a                	mv	a0,s2
    80002c74:	00001097          	auipc	ra,0x1
    80002c78:	ab8080e7          	jalr	-1352(ra) # 8000372c <acquiresleep>
    release(&itable.lock);
    80002c7c:	00015517          	auipc	a0,0x15
    80002c80:	8fc50513          	addi	a0,a0,-1796 # 80017578 <itable>
    80002c84:	00003097          	auipc	ra,0x3
    80002c88:	440080e7          	jalr	1088(ra) # 800060c4 <release>
    itrunc(ip);
    80002c8c:	8526                	mv	a0,s1
    80002c8e:	00000097          	auipc	ra,0x0
    80002c92:	ee2080e7          	jalr	-286(ra) # 80002b70 <itrunc>
    ip->type = 0;
    80002c96:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002c9a:	8526                	mv	a0,s1
    80002c9c:	00000097          	auipc	ra,0x0
    80002ca0:	cfc080e7          	jalr	-772(ra) # 80002998 <iupdate>
    ip->valid = 0;
    80002ca4:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002ca8:	854a                	mv	a0,s2
    80002caa:	00001097          	auipc	ra,0x1
    80002cae:	ad8080e7          	jalr	-1320(ra) # 80003782 <releasesleep>
    acquire(&itable.lock);
    80002cb2:	00015517          	auipc	a0,0x15
    80002cb6:	8c650513          	addi	a0,a0,-1850 # 80017578 <itable>
    80002cba:	00003097          	auipc	ra,0x3
    80002cbe:	356080e7          	jalr	854(ra) # 80006010 <acquire>
    80002cc2:	b741                	j	80002c42 <iput+0x26>

0000000080002cc4 <iunlockput>:
{
    80002cc4:	1101                	addi	sp,sp,-32
    80002cc6:	ec06                	sd	ra,24(sp)
    80002cc8:	e822                	sd	s0,16(sp)
    80002cca:	e426                	sd	s1,8(sp)
    80002ccc:	1000                	addi	s0,sp,32
    80002cce:	84aa                	mv	s1,a0
  iunlock(ip);
    80002cd0:	00000097          	auipc	ra,0x0
    80002cd4:	e54080e7          	jalr	-428(ra) # 80002b24 <iunlock>
  iput(ip);
    80002cd8:	8526                	mv	a0,s1
    80002cda:	00000097          	auipc	ra,0x0
    80002cde:	f42080e7          	jalr	-190(ra) # 80002c1c <iput>
}
    80002ce2:	60e2                	ld	ra,24(sp)
    80002ce4:	6442                	ld	s0,16(sp)
    80002ce6:	64a2                	ld	s1,8(sp)
    80002ce8:	6105                	addi	sp,sp,32
    80002cea:	8082                	ret

0000000080002cec <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002cec:	1141                	addi	sp,sp,-16
    80002cee:	e422                	sd	s0,8(sp)
    80002cf0:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002cf2:	411c                	lw	a5,0(a0)
    80002cf4:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002cf6:	415c                	lw	a5,4(a0)
    80002cf8:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002cfa:	04451783          	lh	a5,68(a0)
    80002cfe:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002d02:	04a51783          	lh	a5,74(a0)
    80002d06:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002d0a:	04c56783          	lwu	a5,76(a0)
    80002d0e:	e99c                	sd	a5,16(a1)
}
    80002d10:	6422                	ld	s0,8(sp)
    80002d12:	0141                	addi	sp,sp,16
    80002d14:	8082                	ret

0000000080002d16 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002d16:	457c                	lw	a5,76(a0)
    80002d18:	0ed7e963          	bltu	a5,a3,80002e0a <readi+0xf4>
{
    80002d1c:	7159                	addi	sp,sp,-112
    80002d1e:	f486                	sd	ra,104(sp)
    80002d20:	f0a2                	sd	s0,96(sp)
    80002d22:	eca6                	sd	s1,88(sp)
    80002d24:	e8ca                	sd	s2,80(sp)
    80002d26:	e4ce                	sd	s3,72(sp)
    80002d28:	e0d2                	sd	s4,64(sp)
    80002d2a:	fc56                	sd	s5,56(sp)
    80002d2c:	f85a                	sd	s6,48(sp)
    80002d2e:	f45e                	sd	s7,40(sp)
    80002d30:	f062                	sd	s8,32(sp)
    80002d32:	ec66                	sd	s9,24(sp)
    80002d34:	e86a                	sd	s10,16(sp)
    80002d36:	e46e                	sd	s11,8(sp)
    80002d38:	1880                	addi	s0,sp,112
    80002d3a:	8baa                	mv	s7,a0
    80002d3c:	8c2e                	mv	s8,a1
    80002d3e:	8ab2                	mv	s5,a2
    80002d40:	84b6                	mv	s1,a3
    80002d42:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002d44:	9f35                	addw	a4,a4,a3
    return 0;
    80002d46:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002d48:	0ad76063          	bltu	a4,a3,80002de8 <readi+0xd2>
  if(off + n > ip->size)
    80002d4c:	00e7f463          	bgeu	a5,a4,80002d54 <readi+0x3e>
    n = ip->size - off;
    80002d50:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002d54:	0a0b0963          	beqz	s6,80002e06 <readi+0xf0>
    80002d58:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002d5a:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002d5e:	5cfd                	li	s9,-1
    80002d60:	a82d                	j	80002d9a <readi+0x84>
    80002d62:	020a1d93          	slli	s11,s4,0x20
    80002d66:	020ddd93          	srli	s11,s11,0x20
    80002d6a:	05890793          	addi	a5,s2,88
    80002d6e:	86ee                	mv	a3,s11
    80002d70:	963e                	add	a2,a2,a5
    80002d72:	85d6                	mv	a1,s5
    80002d74:	8562                	mv	a0,s8
    80002d76:	fffff097          	auipc	ra,0xfffff
    80002d7a:	b30080e7          	jalr	-1232(ra) # 800018a6 <either_copyout>
    80002d7e:	05950d63          	beq	a0,s9,80002dd8 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002d82:	854a                	mv	a0,s2
    80002d84:	fffff097          	auipc	ra,0xfffff
    80002d88:	60c080e7          	jalr	1548(ra) # 80002390 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002d8c:	013a09bb          	addw	s3,s4,s3
    80002d90:	009a04bb          	addw	s1,s4,s1
    80002d94:	9aee                	add	s5,s5,s11
    80002d96:	0569f763          	bgeu	s3,s6,80002de4 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002d9a:	000ba903          	lw	s2,0(s7)
    80002d9e:	00a4d59b          	srliw	a1,s1,0xa
    80002da2:	855e                	mv	a0,s7
    80002da4:	00000097          	auipc	ra,0x0
    80002da8:	8b0080e7          	jalr	-1872(ra) # 80002654 <bmap>
    80002dac:	0005059b          	sext.w	a1,a0
    80002db0:	854a                	mv	a0,s2
    80002db2:	fffff097          	auipc	ra,0xfffff
    80002db6:	4ae080e7          	jalr	1198(ra) # 80002260 <bread>
    80002dba:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002dbc:	3ff4f613          	andi	a2,s1,1023
    80002dc0:	40cd07bb          	subw	a5,s10,a2
    80002dc4:	413b073b          	subw	a4,s6,s3
    80002dc8:	8a3e                	mv	s4,a5
    80002dca:	2781                	sext.w	a5,a5
    80002dcc:	0007069b          	sext.w	a3,a4
    80002dd0:	f8f6f9e3          	bgeu	a3,a5,80002d62 <readi+0x4c>
    80002dd4:	8a3a                	mv	s4,a4
    80002dd6:	b771                	j	80002d62 <readi+0x4c>
      brelse(bp);
    80002dd8:	854a                	mv	a0,s2
    80002dda:	fffff097          	auipc	ra,0xfffff
    80002dde:	5b6080e7          	jalr	1462(ra) # 80002390 <brelse>
      tot = -1;
    80002de2:	59fd                	li	s3,-1
  }
  return tot;
    80002de4:	0009851b          	sext.w	a0,s3
}
    80002de8:	70a6                	ld	ra,104(sp)
    80002dea:	7406                	ld	s0,96(sp)
    80002dec:	64e6                	ld	s1,88(sp)
    80002dee:	6946                	ld	s2,80(sp)
    80002df0:	69a6                	ld	s3,72(sp)
    80002df2:	6a06                	ld	s4,64(sp)
    80002df4:	7ae2                	ld	s5,56(sp)
    80002df6:	7b42                	ld	s6,48(sp)
    80002df8:	7ba2                	ld	s7,40(sp)
    80002dfa:	7c02                	ld	s8,32(sp)
    80002dfc:	6ce2                	ld	s9,24(sp)
    80002dfe:	6d42                	ld	s10,16(sp)
    80002e00:	6da2                	ld	s11,8(sp)
    80002e02:	6165                	addi	sp,sp,112
    80002e04:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e06:	89da                	mv	s3,s6
    80002e08:	bff1                	j	80002de4 <readi+0xce>
    return 0;
    80002e0a:	4501                	li	a0,0
}
    80002e0c:	8082                	ret

0000000080002e0e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e0e:	457c                	lw	a5,76(a0)
    80002e10:	10d7e863          	bltu	a5,a3,80002f20 <writei+0x112>
{
    80002e14:	7159                	addi	sp,sp,-112
    80002e16:	f486                	sd	ra,104(sp)
    80002e18:	f0a2                	sd	s0,96(sp)
    80002e1a:	eca6                	sd	s1,88(sp)
    80002e1c:	e8ca                	sd	s2,80(sp)
    80002e1e:	e4ce                	sd	s3,72(sp)
    80002e20:	e0d2                	sd	s4,64(sp)
    80002e22:	fc56                	sd	s5,56(sp)
    80002e24:	f85a                	sd	s6,48(sp)
    80002e26:	f45e                	sd	s7,40(sp)
    80002e28:	f062                	sd	s8,32(sp)
    80002e2a:	ec66                	sd	s9,24(sp)
    80002e2c:	e86a                	sd	s10,16(sp)
    80002e2e:	e46e                	sd	s11,8(sp)
    80002e30:	1880                	addi	s0,sp,112
    80002e32:	8b2a                	mv	s6,a0
    80002e34:	8c2e                	mv	s8,a1
    80002e36:	8ab2                	mv	s5,a2
    80002e38:	8936                	mv	s2,a3
    80002e3a:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002e3c:	00e687bb          	addw	a5,a3,a4
    80002e40:	0ed7e263          	bltu	a5,a3,80002f24 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002e44:	00043737          	lui	a4,0x43
    80002e48:	0ef76063          	bltu	a4,a5,80002f28 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002e4c:	0c0b8863          	beqz	s7,80002f1c <writei+0x10e>
    80002e50:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e52:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002e56:	5cfd                	li	s9,-1
    80002e58:	a091                	j	80002e9c <writei+0x8e>
    80002e5a:	02099d93          	slli	s11,s3,0x20
    80002e5e:	020ddd93          	srli	s11,s11,0x20
    80002e62:	05848793          	addi	a5,s1,88
    80002e66:	86ee                	mv	a3,s11
    80002e68:	8656                	mv	a2,s5
    80002e6a:	85e2                	mv	a1,s8
    80002e6c:	953e                	add	a0,a0,a5
    80002e6e:	fffff097          	auipc	ra,0xfffff
    80002e72:	a8e080e7          	jalr	-1394(ra) # 800018fc <either_copyin>
    80002e76:	07950263          	beq	a0,s9,80002eda <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002e7a:	8526                	mv	a0,s1
    80002e7c:	00000097          	auipc	ra,0x0
    80002e80:	790080e7          	jalr	1936(ra) # 8000360c <log_write>
    brelse(bp);
    80002e84:	8526                	mv	a0,s1
    80002e86:	fffff097          	auipc	ra,0xfffff
    80002e8a:	50a080e7          	jalr	1290(ra) # 80002390 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002e8e:	01498a3b          	addw	s4,s3,s4
    80002e92:	0129893b          	addw	s2,s3,s2
    80002e96:	9aee                	add	s5,s5,s11
    80002e98:	057a7663          	bgeu	s4,s7,80002ee4 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002e9c:	000b2483          	lw	s1,0(s6)
    80002ea0:	00a9559b          	srliw	a1,s2,0xa
    80002ea4:	855a                	mv	a0,s6
    80002ea6:	fffff097          	auipc	ra,0xfffff
    80002eaa:	7ae080e7          	jalr	1966(ra) # 80002654 <bmap>
    80002eae:	0005059b          	sext.w	a1,a0
    80002eb2:	8526                	mv	a0,s1
    80002eb4:	fffff097          	auipc	ra,0xfffff
    80002eb8:	3ac080e7          	jalr	940(ra) # 80002260 <bread>
    80002ebc:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ebe:	3ff97513          	andi	a0,s2,1023
    80002ec2:	40ad07bb          	subw	a5,s10,a0
    80002ec6:	414b873b          	subw	a4,s7,s4
    80002eca:	89be                	mv	s3,a5
    80002ecc:	2781                	sext.w	a5,a5
    80002ece:	0007069b          	sext.w	a3,a4
    80002ed2:	f8f6f4e3          	bgeu	a3,a5,80002e5a <writei+0x4c>
    80002ed6:	89ba                	mv	s3,a4
    80002ed8:	b749                	j	80002e5a <writei+0x4c>
      brelse(bp);
    80002eda:	8526                	mv	a0,s1
    80002edc:	fffff097          	auipc	ra,0xfffff
    80002ee0:	4b4080e7          	jalr	1204(ra) # 80002390 <brelse>
  }

  if(off > ip->size)
    80002ee4:	04cb2783          	lw	a5,76(s6)
    80002ee8:	0127f463          	bgeu	a5,s2,80002ef0 <writei+0xe2>
    ip->size = off;
    80002eec:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002ef0:	855a                	mv	a0,s6
    80002ef2:	00000097          	auipc	ra,0x0
    80002ef6:	aa6080e7          	jalr	-1370(ra) # 80002998 <iupdate>

  return tot;
    80002efa:	000a051b          	sext.w	a0,s4
}
    80002efe:	70a6                	ld	ra,104(sp)
    80002f00:	7406                	ld	s0,96(sp)
    80002f02:	64e6                	ld	s1,88(sp)
    80002f04:	6946                	ld	s2,80(sp)
    80002f06:	69a6                	ld	s3,72(sp)
    80002f08:	6a06                	ld	s4,64(sp)
    80002f0a:	7ae2                	ld	s5,56(sp)
    80002f0c:	7b42                	ld	s6,48(sp)
    80002f0e:	7ba2                	ld	s7,40(sp)
    80002f10:	7c02                	ld	s8,32(sp)
    80002f12:	6ce2                	ld	s9,24(sp)
    80002f14:	6d42                	ld	s10,16(sp)
    80002f16:	6da2                	ld	s11,8(sp)
    80002f18:	6165                	addi	sp,sp,112
    80002f1a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f1c:	8a5e                	mv	s4,s7
    80002f1e:	bfc9                	j	80002ef0 <writei+0xe2>
    return -1;
    80002f20:	557d                	li	a0,-1
}
    80002f22:	8082                	ret
    return -1;
    80002f24:	557d                	li	a0,-1
    80002f26:	bfe1                	j	80002efe <writei+0xf0>
    return -1;
    80002f28:	557d                	li	a0,-1
    80002f2a:	bfd1                	j	80002efe <writei+0xf0>

0000000080002f2c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002f2c:	1141                	addi	sp,sp,-16
    80002f2e:	e406                	sd	ra,8(sp)
    80002f30:	e022                	sd	s0,0(sp)
    80002f32:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002f34:	4639                	li	a2,14
    80002f36:	ffffd097          	auipc	ra,0xffffd
    80002f3a:	312080e7          	jalr	786(ra) # 80000248 <strncmp>
}
    80002f3e:	60a2                	ld	ra,8(sp)
    80002f40:	6402                	ld	s0,0(sp)
    80002f42:	0141                	addi	sp,sp,16
    80002f44:	8082                	ret

0000000080002f46 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002f46:	7139                	addi	sp,sp,-64
    80002f48:	fc06                	sd	ra,56(sp)
    80002f4a:	f822                	sd	s0,48(sp)
    80002f4c:	f426                	sd	s1,40(sp)
    80002f4e:	f04a                	sd	s2,32(sp)
    80002f50:	ec4e                	sd	s3,24(sp)
    80002f52:	e852                	sd	s4,16(sp)
    80002f54:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002f56:	04451703          	lh	a4,68(a0)
    80002f5a:	4785                	li	a5,1
    80002f5c:	00f71a63          	bne	a4,a5,80002f70 <dirlookup+0x2a>
    80002f60:	892a                	mv	s2,a0
    80002f62:	89ae                	mv	s3,a1
    80002f64:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002f66:	457c                	lw	a5,76(a0)
    80002f68:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002f6a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002f6c:	e79d                	bnez	a5,80002f9a <dirlookup+0x54>
    80002f6e:	a8a5                	j	80002fe6 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80002f70:	00005517          	auipc	a0,0x5
    80002f74:	5f850513          	addi	a0,a0,1528 # 80008568 <syscalls+0x1a0>
    80002f78:	00003097          	auipc	ra,0x3
    80002f7c:	b5c080e7          	jalr	-1188(ra) # 80005ad4 <panic>
      panic("dirlookup read");
    80002f80:	00005517          	auipc	a0,0x5
    80002f84:	60050513          	addi	a0,a0,1536 # 80008580 <syscalls+0x1b8>
    80002f88:	00003097          	auipc	ra,0x3
    80002f8c:	b4c080e7          	jalr	-1204(ra) # 80005ad4 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002f90:	24c1                	addiw	s1,s1,16
    80002f92:	04c92783          	lw	a5,76(s2)
    80002f96:	04f4f763          	bgeu	s1,a5,80002fe4 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002f9a:	4741                	li	a4,16
    80002f9c:	86a6                	mv	a3,s1
    80002f9e:	fc040613          	addi	a2,s0,-64
    80002fa2:	4581                	li	a1,0
    80002fa4:	854a                	mv	a0,s2
    80002fa6:	00000097          	auipc	ra,0x0
    80002faa:	d70080e7          	jalr	-656(ra) # 80002d16 <readi>
    80002fae:	47c1                	li	a5,16
    80002fb0:	fcf518e3          	bne	a0,a5,80002f80 <dirlookup+0x3a>
    if(de.inum == 0)
    80002fb4:	fc045783          	lhu	a5,-64(s0)
    80002fb8:	dfe1                	beqz	a5,80002f90 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80002fba:	fc240593          	addi	a1,s0,-62
    80002fbe:	854e                	mv	a0,s3
    80002fc0:	00000097          	auipc	ra,0x0
    80002fc4:	f6c080e7          	jalr	-148(ra) # 80002f2c <namecmp>
    80002fc8:	f561                	bnez	a0,80002f90 <dirlookup+0x4a>
      if(poff)
    80002fca:	000a0463          	beqz	s4,80002fd2 <dirlookup+0x8c>
        *poff = off;
    80002fce:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002fd2:	fc045583          	lhu	a1,-64(s0)
    80002fd6:	00092503          	lw	a0,0(s2)
    80002fda:	fffff097          	auipc	ra,0xfffff
    80002fde:	754080e7          	jalr	1876(ra) # 8000272e <iget>
    80002fe2:	a011                	j	80002fe6 <dirlookup+0xa0>
  return 0;
    80002fe4:	4501                	li	a0,0
}
    80002fe6:	70e2                	ld	ra,56(sp)
    80002fe8:	7442                	ld	s0,48(sp)
    80002fea:	74a2                	ld	s1,40(sp)
    80002fec:	7902                	ld	s2,32(sp)
    80002fee:	69e2                	ld	s3,24(sp)
    80002ff0:	6a42                	ld	s4,16(sp)
    80002ff2:	6121                	addi	sp,sp,64
    80002ff4:	8082                	ret

0000000080002ff6 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002ff6:	711d                	addi	sp,sp,-96
    80002ff8:	ec86                	sd	ra,88(sp)
    80002ffa:	e8a2                	sd	s0,80(sp)
    80002ffc:	e4a6                	sd	s1,72(sp)
    80002ffe:	e0ca                	sd	s2,64(sp)
    80003000:	fc4e                	sd	s3,56(sp)
    80003002:	f852                	sd	s4,48(sp)
    80003004:	f456                	sd	s5,40(sp)
    80003006:	f05a                	sd	s6,32(sp)
    80003008:	ec5e                	sd	s7,24(sp)
    8000300a:	e862                	sd	s8,16(sp)
    8000300c:	e466                	sd	s9,8(sp)
    8000300e:	1080                	addi	s0,sp,96
    80003010:	84aa                	mv	s1,a0
    80003012:	8aae                	mv	s5,a1
    80003014:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003016:	00054703          	lbu	a4,0(a0)
    8000301a:	02f00793          	li	a5,47
    8000301e:	02f70363          	beq	a4,a5,80003044 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003022:	ffffe097          	auipc	ra,0xffffe
    80003026:	e20080e7          	jalr	-480(ra) # 80000e42 <myproc>
    8000302a:	15053503          	ld	a0,336(a0)
    8000302e:	00000097          	auipc	ra,0x0
    80003032:	9f6080e7          	jalr	-1546(ra) # 80002a24 <idup>
    80003036:	89aa                	mv	s3,a0
  while(*path == '/')
    80003038:	02f00913          	li	s2,47
  len = path - s;
    8000303c:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    8000303e:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003040:	4b85                	li	s7,1
    80003042:	a865                	j	800030fa <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003044:	4585                	li	a1,1
    80003046:	4505                	li	a0,1
    80003048:	fffff097          	auipc	ra,0xfffff
    8000304c:	6e6080e7          	jalr	1766(ra) # 8000272e <iget>
    80003050:	89aa                	mv	s3,a0
    80003052:	b7dd                	j	80003038 <namex+0x42>
      iunlockput(ip);
    80003054:	854e                	mv	a0,s3
    80003056:	00000097          	auipc	ra,0x0
    8000305a:	c6e080e7          	jalr	-914(ra) # 80002cc4 <iunlockput>
      return 0;
    8000305e:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003060:	854e                	mv	a0,s3
    80003062:	60e6                	ld	ra,88(sp)
    80003064:	6446                	ld	s0,80(sp)
    80003066:	64a6                	ld	s1,72(sp)
    80003068:	6906                	ld	s2,64(sp)
    8000306a:	79e2                	ld	s3,56(sp)
    8000306c:	7a42                	ld	s4,48(sp)
    8000306e:	7aa2                	ld	s5,40(sp)
    80003070:	7b02                	ld	s6,32(sp)
    80003072:	6be2                	ld	s7,24(sp)
    80003074:	6c42                	ld	s8,16(sp)
    80003076:	6ca2                	ld	s9,8(sp)
    80003078:	6125                	addi	sp,sp,96
    8000307a:	8082                	ret
      iunlock(ip);
    8000307c:	854e                	mv	a0,s3
    8000307e:	00000097          	auipc	ra,0x0
    80003082:	aa6080e7          	jalr	-1370(ra) # 80002b24 <iunlock>
      return ip;
    80003086:	bfe9                	j	80003060 <namex+0x6a>
      iunlockput(ip);
    80003088:	854e                	mv	a0,s3
    8000308a:	00000097          	auipc	ra,0x0
    8000308e:	c3a080e7          	jalr	-966(ra) # 80002cc4 <iunlockput>
      return 0;
    80003092:	89e6                	mv	s3,s9
    80003094:	b7f1                	j	80003060 <namex+0x6a>
  len = path - s;
    80003096:	40b48633          	sub	a2,s1,a1
    8000309a:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000309e:	099c5463          	bge	s8,s9,80003126 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800030a2:	4639                	li	a2,14
    800030a4:	8552                	mv	a0,s4
    800030a6:	ffffd097          	auipc	ra,0xffffd
    800030aa:	12e080e7          	jalr	302(ra) # 800001d4 <memmove>
  while(*path == '/')
    800030ae:	0004c783          	lbu	a5,0(s1)
    800030b2:	01279763          	bne	a5,s2,800030c0 <namex+0xca>
    path++;
    800030b6:	0485                	addi	s1,s1,1
  while(*path == '/')
    800030b8:	0004c783          	lbu	a5,0(s1)
    800030bc:	ff278de3          	beq	a5,s2,800030b6 <namex+0xc0>
    ilock(ip);
    800030c0:	854e                	mv	a0,s3
    800030c2:	00000097          	auipc	ra,0x0
    800030c6:	9a0080e7          	jalr	-1632(ra) # 80002a62 <ilock>
    if(ip->type != T_DIR){
    800030ca:	04499783          	lh	a5,68(s3)
    800030ce:	f97793e3          	bne	a5,s7,80003054 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800030d2:	000a8563          	beqz	s5,800030dc <namex+0xe6>
    800030d6:	0004c783          	lbu	a5,0(s1)
    800030da:	d3cd                	beqz	a5,8000307c <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800030dc:	865a                	mv	a2,s6
    800030de:	85d2                	mv	a1,s4
    800030e0:	854e                	mv	a0,s3
    800030e2:	00000097          	auipc	ra,0x0
    800030e6:	e64080e7          	jalr	-412(ra) # 80002f46 <dirlookup>
    800030ea:	8caa                	mv	s9,a0
    800030ec:	dd51                	beqz	a0,80003088 <namex+0x92>
    iunlockput(ip);
    800030ee:	854e                	mv	a0,s3
    800030f0:	00000097          	auipc	ra,0x0
    800030f4:	bd4080e7          	jalr	-1068(ra) # 80002cc4 <iunlockput>
    ip = next;
    800030f8:	89e6                	mv	s3,s9
  while(*path == '/')
    800030fa:	0004c783          	lbu	a5,0(s1)
    800030fe:	05279763          	bne	a5,s2,8000314c <namex+0x156>
    path++;
    80003102:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003104:	0004c783          	lbu	a5,0(s1)
    80003108:	ff278de3          	beq	a5,s2,80003102 <namex+0x10c>
  if(*path == 0)
    8000310c:	c79d                	beqz	a5,8000313a <namex+0x144>
    path++;
    8000310e:	85a6                	mv	a1,s1
  len = path - s;
    80003110:	8cda                	mv	s9,s6
    80003112:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80003114:	01278963          	beq	a5,s2,80003126 <namex+0x130>
    80003118:	dfbd                	beqz	a5,80003096 <namex+0xa0>
    path++;
    8000311a:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000311c:	0004c783          	lbu	a5,0(s1)
    80003120:	ff279ce3          	bne	a5,s2,80003118 <namex+0x122>
    80003124:	bf8d                	j	80003096 <namex+0xa0>
    memmove(name, s, len);
    80003126:	2601                	sext.w	a2,a2
    80003128:	8552                	mv	a0,s4
    8000312a:	ffffd097          	auipc	ra,0xffffd
    8000312e:	0aa080e7          	jalr	170(ra) # 800001d4 <memmove>
    name[len] = 0;
    80003132:	9cd2                	add	s9,s9,s4
    80003134:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003138:	bf9d                	j	800030ae <namex+0xb8>
  if(nameiparent){
    8000313a:	f20a83e3          	beqz	s5,80003060 <namex+0x6a>
    iput(ip);
    8000313e:	854e                	mv	a0,s3
    80003140:	00000097          	auipc	ra,0x0
    80003144:	adc080e7          	jalr	-1316(ra) # 80002c1c <iput>
    return 0;
    80003148:	4981                	li	s3,0
    8000314a:	bf19                	j	80003060 <namex+0x6a>
  if(*path == 0)
    8000314c:	d7fd                	beqz	a5,8000313a <namex+0x144>
  while(*path != '/' && *path != 0)
    8000314e:	0004c783          	lbu	a5,0(s1)
    80003152:	85a6                	mv	a1,s1
    80003154:	b7d1                	j	80003118 <namex+0x122>

0000000080003156 <dirlink>:
{
    80003156:	7139                	addi	sp,sp,-64
    80003158:	fc06                	sd	ra,56(sp)
    8000315a:	f822                	sd	s0,48(sp)
    8000315c:	f426                	sd	s1,40(sp)
    8000315e:	f04a                	sd	s2,32(sp)
    80003160:	ec4e                	sd	s3,24(sp)
    80003162:	e852                	sd	s4,16(sp)
    80003164:	0080                	addi	s0,sp,64
    80003166:	892a                	mv	s2,a0
    80003168:	8a2e                	mv	s4,a1
    8000316a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000316c:	4601                	li	a2,0
    8000316e:	00000097          	auipc	ra,0x0
    80003172:	dd8080e7          	jalr	-552(ra) # 80002f46 <dirlookup>
    80003176:	e93d                	bnez	a0,800031ec <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003178:	04c92483          	lw	s1,76(s2)
    8000317c:	c49d                	beqz	s1,800031aa <dirlink+0x54>
    8000317e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003180:	4741                	li	a4,16
    80003182:	86a6                	mv	a3,s1
    80003184:	fc040613          	addi	a2,s0,-64
    80003188:	4581                	li	a1,0
    8000318a:	854a                	mv	a0,s2
    8000318c:	00000097          	auipc	ra,0x0
    80003190:	b8a080e7          	jalr	-1142(ra) # 80002d16 <readi>
    80003194:	47c1                	li	a5,16
    80003196:	06f51163          	bne	a0,a5,800031f8 <dirlink+0xa2>
    if(de.inum == 0)
    8000319a:	fc045783          	lhu	a5,-64(s0)
    8000319e:	c791                	beqz	a5,800031aa <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031a0:	24c1                	addiw	s1,s1,16
    800031a2:	04c92783          	lw	a5,76(s2)
    800031a6:	fcf4ede3          	bltu	s1,a5,80003180 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800031aa:	4639                	li	a2,14
    800031ac:	85d2                	mv	a1,s4
    800031ae:	fc240513          	addi	a0,s0,-62
    800031b2:	ffffd097          	auipc	ra,0xffffd
    800031b6:	0d2080e7          	jalr	210(ra) # 80000284 <strncpy>
  de.inum = inum;
    800031ba:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031be:	4741                	li	a4,16
    800031c0:	86a6                	mv	a3,s1
    800031c2:	fc040613          	addi	a2,s0,-64
    800031c6:	4581                	li	a1,0
    800031c8:	854a                	mv	a0,s2
    800031ca:	00000097          	auipc	ra,0x0
    800031ce:	c44080e7          	jalr	-956(ra) # 80002e0e <writei>
    800031d2:	872a                	mv	a4,a0
    800031d4:	47c1                	li	a5,16
  return 0;
    800031d6:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031d8:	02f71863          	bne	a4,a5,80003208 <dirlink+0xb2>
}
    800031dc:	70e2                	ld	ra,56(sp)
    800031de:	7442                	ld	s0,48(sp)
    800031e0:	74a2                	ld	s1,40(sp)
    800031e2:	7902                	ld	s2,32(sp)
    800031e4:	69e2                	ld	s3,24(sp)
    800031e6:	6a42                	ld	s4,16(sp)
    800031e8:	6121                	addi	sp,sp,64
    800031ea:	8082                	ret
    iput(ip);
    800031ec:	00000097          	auipc	ra,0x0
    800031f0:	a30080e7          	jalr	-1488(ra) # 80002c1c <iput>
    return -1;
    800031f4:	557d                	li	a0,-1
    800031f6:	b7dd                	j	800031dc <dirlink+0x86>
      panic("dirlink read");
    800031f8:	00005517          	auipc	a0,0x5
    800031fc:	39850513          	addi	a0,a0,920 # 80008590 <syscalls+0x1c8>
    80003200:	00003097          	auipc	ra,0x3
    80003204:	8d4080e7          	jalr	-1836(ra) # 80005ad4 <panic>
    panic("dirlink");
    80003208:	00005517          	auipc	a0,0x5
    8000320c:	49850513          	addi	a0,a0,1176 # 800086a0 <syscalls+0x2d8>
    80003210:	00003097          	auipc	ra,0x3
    80003214:	8c4080e7          	jalr	-1852(ra) # 80005ad4 <panic>

0000000080003218 <namei>:

struct inode*
namei(char *path)
{
    80003218:	1101                	addi	sp,sp,-32
    8000321a:	ec06                	sd	ra,24(sp)
    8000321c:	e822                	sd	s0,16(sp)
    8000321e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003220:	fe040613          	addi	a2,s0,-32
    80003224:	4581                	li	a1,0
    80003226:	00000097          	auipc	ra,0x0
    8000322a:	dd0080e7          	jalr	-560(ra) # 80002ff6 <namex>
}
    8000322e:	60e2                	ld	ra,24(sp)
    80003230:	6442                	ld	s0,16(sp)
    80003232:	6105                	addi	sp,sp,32
    80003234:	8082                	ret

0000000080003236 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003236:	1141                	addi	sp,sp,-16
    80003238:	e406                	sd	ra,8(sp)
    8000323a:	e022                	sd	s0,0(sp)
    8000323c:	0800                	addi	s0,sp,16
    8000323e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003240:	4585                	li	a1,1
    80003242:	00000097          	auipc	ra,0x0
    80003246:	db4080e7          	jalr	-588(ra) # 80002ff6 <namex>
}
    8000324a:	60a2                	ld	ra,8(sp)
    8000324c:	6402                	ld	s0,0(sp)
    8000324e:	0141                	addi	sp,sp,16
    80003250:	8082                	ret

0000000080003252 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003252:	1101                	addi	sp,sp,-32
    80003254:	ec06                	sd	ra,24(sp)
    80003256:	e822                	sd	s0,16(sp)
    80003258:	e426                	sd	s1,8(sp)
    8000325a:	e04a                	sd	s2,0(sp)
    8000325c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000325e:	00016917          	auipc	s2,0x16
    80003262:	dc290913          	addi	s2,s2,-574 # 80019020 <log>
    80003266:	01892583          	lw	a1,24(s2)
    8000326a:	02892503          	lw	a0,40(s2)
    8000326e:	fffff097          	auipc	ra,0xfffff
    80003272:	ff2080e7          	jalr	-14(ra) # 80002260 <bread>
    80003276:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003278:	02c92683          	lw	a3,44(s2)
    8000327c:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000327e:	02d05763          	blez	a3,800032ac <write_head+0x5a>
    80003282:	00016797          	auipc	a5,0x16
    80003286:	dce78793          	addi	a5,a5,-562 # 80019050 <log+0x30>
    8000328a:	05c50713          	addi	a4,a0,92
    8000328e:	36fd                	addiw	a3,a3,-1
    80003290:	1682                	slli	a3,a3,0x20
    80003292:	9281                	srli	a3,a3,0x20
    80003294:	068a                	slli	a3,a3,0x2
    80003296:	00016617          	auipc	a2,0x16
    8000329a:	dbe60613          	addi	a2,a2,-578 # 80019054 <log+0x34>
    8000329e:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800032a0:	4390                	lw	a2,0(a5)
    800032a2:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800032a4:	0791                	addi	a5,a5,4
    800032a6:	0711                	addi	a4,a4,4
    800032a8:	fed79ce3          	bne	a5,a3,800032a0 <write_head+0x4e>
  }
  bwrite(buf);
    800032ac:	8526                	mv	a0,s1
    800032ae:	fffff097          	auipc	ra,0xfffff
    800032b2:	0a4080e7          	jalr	164(ra) # 80002352 <bwrite>
  brelse(buf);
    800032b6:	8526                	mv	a0,s1
    800032b8:	fffff097          	auipc	ra,0xfffff
    800032bc:	0d8080e7          	jalr	216(ra) # 80002390 <brelse>
}
    800032c0:	60e2                	ld	ra,24(sp)
    800032c2:	6442                	ld	s0,16(sp)
    800032c4:	64a2                	ld	s1,8(sp)
    800032c6:	6902                	ld	s2,0(sp)
    800032c8:	6105                	addi	sp,sp,32
    800032ca:	8082                	ret

00000000800032cc <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800032cc:	00016797          	auipc	a5,0x16
    800032d0:	d807a783          	lw	a5,-640(a5) # 8001904c <log+0x2c>
    800032d4:	0af05d63          	blez	a5,8000338e <install_trans+0xc2>
{
    800032d8:	7139                	addi	sp,sp,-64
    800032da:	fc06                	sd	ra,56(sp)
    800032dc:	f822                	sd	s0,48(sp)
    800032de:	f426                	sd	s1,40(sp)
    800032e0:	f04a                	sd	s2,32(sp)
    800032e2:	ec4e                	sd	s3,24(sp)
    800032e4:	e852                	sd	s4,16(sp)
    800032e6:	e456                	sd	s5,8(sp)
    800032e8:	e05a                	sd	s6,0(sp)
    800032ea:	0080                	addi	s0,sp,64
    800032ec:	8b2a                	mv	s6,a0
    800032ee:	00016a97          	auipc	s5,0x16
    800032f2:	d62a8a93          	addi	s5,s5,-670 # 80019050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800032f6:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800032f8:	00016997          	auipc	s3,0x16
    800032fc:	d2898993          	addi	s3,s3,-728 # 80019020 <log>
    80003300:	a00d                	j	80003322 <install_trans+0x56>
    brelse(lbuf);
    80003302:	854a                	mv	a0,s2
    80003304:	fffff097          	auipc	ra,0xfffff
    80003308:	08c080e7          	jalr	140(ra) # 80002390 <brelse>
    brelse(dbuf);
    8000330c:	8526                	mv	a0,s1
    8000330e:	fffff097          	auipc	ra,0xfffff
    80003312:	082080e7          	jalr	130(ra) # 80002390 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003316:	2a05                	addiw	s4,s4,1
    80003318:	0a91                	addi	s5,s5,4
    8000331a:	02c9a783          	lw	a5,44(s3)
    8000331e:	04fa5e63          	bge	s4,a5,8000337a <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003322:	0189a583          	lw	a1,24(s3)
    80003326:	014585bb          	addw	a1,a1,s4
    8000332a:	2585                	addiw	a1,a1,1
    8000332c:	0289a503          	lw	a0,40(s3)
    80003330:	fffff097          	auipc	ra,0xfffff
    80003334:	f30080e7          	jalr	-208(ra) # 80002260 <bread>
    80003338:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000333a:	000aa583          	lw	a1,0(s5)
    8000333e:	0289a503          	lw	a0,40(s3)
    80003342:	fffff097          	auipc	ra,0xfffff
    80003346:	f1e080e7          	jalr	-226(ra) # 80002260 <bread>
    8000334a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000334c:	40000613          	li	a2,1024
    80003350:	05890593          	addi	a1,s2,88
    80003354:	05850513          	addi	a0,a0,88
    80003358:	ffffd097          	auipc	ra,0xffffd
    8000335c:	e7c080e7          	jalr	-388(ra) # 800001d4 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003360:	8526                	mv	a0,s1
    80003362:	fffff097          	auipc	ra,0xfffff
    80003366:	ff0080e7          	jalr	-16(ra) # 80002352 <bwrite>
    if(recovering == 0)
    8000336a:	f80b1ce3          	bnez	s6,80003302 <install_trans+0x36>
      bunpin(dbuf);
    8000336e:	8526                	mv	a0,s1
    80003370:	fffff097          	auipc	ra,0xfffff
    80003374:	0fa080e7          	jalr	250(ra) # 8000246a <bunpin>
    80003378:	b769                	j	80003302 <install_trans+0x36>
}
    8000337a:	70e2                	ld	ra,56(sp)
    8000337c:	7442                	ld	s0,48(sp)
    8000337e:	74a2                	ld	s1,40(sp)
    80003380:	7902                	ld	s2,32(sp)
    80003382:	69e2                	ld	s3,24(sp)
    80003384:	6a42                	ld	s4,16(sp)
    80003386:	6aa2                	ld	s5,8(sp)
    80003388:	6b02                	ld	s6,0(sp)
    8000338a:	6121                	addi	sp,sp,64
    8000338c:	8082                	ret
    8000338e:	8082                	ret

0000000080003390 <initlog>:
{
    80003390:	7179                	addi	sp,sp,-48
    80003392:	f406                	sd	ra,40(sp)
    80003394:	f022                	sd	s0,32(sp)
    80003396:	ec26                	sd	s1,24(sp)
    80003398:	e84a                	sd	s2,16(sp)
    8000339a:	e44e                	sd	s3,8(sp)
    8000339c:	1800                	addi	s0,sp,48
    8000339e:	892a                	mv	s2,a0
    800033a0:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800033a2:	00016497          	auipc	s1,0x16
    800033a6:	c7e48493          	addi	s1,s1,-898 # 80019020 <log>
    800033aa:	00005597          	auipc	a1,0x5
    800033ae:	1f658593          	addi	a1,a1,502 # 800085a0 <syscalls+0x1d8>
    800033b2:	8526                	mv	a0,s1
    800033b4:	00003097          	auipc	ra,0x3
    800033b8:	bcc080e7          	jalr	-1076(ra) # 80005f80 <initlock>
  log.start = sb->logstart;
    800033bc:	0149a583          	lw	a1,20(s3)
    800033c0:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800033c2:	0109a783          	lw	a5,16(s3)
    800033c6:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800033c8:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800033cc:	854a                	mv	a0,s2
    800033ce:	fffff097          	auipc	ra,0xfffff
    800033d2:	e92080e7          	jalr	-366(ra) # 80002260 <bread>
  log.lh.n = lh->n;
    800033d6:	4d34                	lw	a3,88(a0)
    800033d8:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800033da:	02d05563          	blez	a3,80003404 <initlog+0x74>
    800033de:	05c50793          	addi	a5,a0,92
    800033e2:	00016717          	auipc	a4,0x16
    800033e6:	c6e70713          	addi	a4,a4,-914 # 80019050 <log+0x30>
    800033ea:	36fd                	addiw	a3,a3,-1
    800033ec:	1682                	slli	a3,a3,0x20
    800033ee:	9281                	srli	a3,a3,0x20
    800033f0:	068a                	slli	a3,a3,0x2
    800033f2:	06050613          	addi	a2,a0,96
    800033f6:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800033f8:	4390                	lw	a2,0(a5)
    800033fa:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800033fc:	0791                	addi	a5,a5,4
    800033fe:	0711                	addi	a4,a4,4
    80003400:	fed79ce3          	bne	a5,a3,800033f8 <initlog+0x68>
  brelse(buf);
    80003404:	fffff097          	auipc	ra,0xfffff
    80003408:	f8c080e7          	jalr	-116(ra) # 80002390 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000340c:	4505                	li	a0,1
    8000340e:	00000097          	auipc	ra,0x0
    80003412:	ebe080e7          	jalr	-322(ra) # 800032cc <install_trans>
  log.lh.n = 0;
    80003416:	00016797          	auipc	a5,0x16
    8000341a:	c207ab23          	sw	zero,-970(a5) # 8001904c <log+0x2c>
  write_head(); // clear the log
    8000341e:	00000097          	auipc	ra,0x0
    80003422:	e34080e7          	jalr	-460(ra) # 80003252 <write_head>
}
    80003426:	70a2                	ld	ra,40(sp)
    80003428:	7402                	ld	s0,32(sp)
    8000342a:	64e2                	ld	s1,24(sp)
    8000342c:	6942                	ld	s2,16(sp)
    8000342e:	69a2                	ld	s3,8(sp)
    80003430:	6145                	addi	sp,sp,48
    80003432:	8082                	ret

0000000080003434 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003434:	1101                	addi	sp,sp,-32
    80003436:	ec06                	sd	ra,24(sp)
    80003438:	e822                	sd	s0,16(sp)
    8000343a:	e426                	sd	s1,8(sp)
    8000343c:	e04a                	sd	s2,0(sp)
    8000343e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003440:	00016517          	auipc	a0,0x16
    80003444:	be050513          	addi	a0,a0,-1056 # 80019020 <log>
    80003448:	00003097          	auipc	ra,0x3
    8000344c:	bc8080e7          	jalr	-1080(ra) # 80006010 <acquire>
  while(1){
    if(log.committing){
    80003450:	00016497          	auipc	s1,0x16
    80003454:	bd048493          	addi	s1,s1,-1072 # 80019020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003458:	4979                	li	s2,30
    8000345a:	a039                	j	80003468 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000345c:	85a6                	mv	a1,s1
    8000345e:	8526                	mv	a0,s1
    80003460:	ffffe097          	auipc	ra,0xffffe
    80003464:	0a2080e7          	jalr	162(ra) # 80001502 <sleep>
    if(log.committing){
    80003468:	50dc                	lw	a5,36(s1)
    8000346a:	fbed                	bnez	a5,8000345c <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000346c:	509c                	lw	a5,32(s1)
    8000346e:	0017871b          	addiw	a4,a5,1
    80003472:	0007069b          	sext.w	a3,a4
    80003476:	0027179b          	slliw	a5,a4,0x2
    8000347a:	9fb9                	addw	a5,a5,a4
    8000347c:	0017979b          	slliw	a5,a5,0x1
    80003480:	54d8                	lw	a4,44(s1)
    80003482:	9fb9                	addw	a5,a5,a4
    80003484:	00f95963          	bge	s2,a5,80003496 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003488:	85a6                	mv	a1,s1
    8000348a:	8526                	mv	a0,s1
    8000348c:	ffffe097          	auipc	ra,0xffffe
    80003490:	076080e7          	jalr	118(ra) # 80001502 <sleep>
    80003494:	bfd1                	j	80003468 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003496:	00016517          	auipc	a0,0x16
    8000349a:	b8a50513          	addi	a0,a0,-1142 # 80019020 <log>
    8000349e:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800034a0:	00003097          	auipc	ra,0x3
    800034a4:	c24080e7          	jalr	-988(ra) # 800060c4 <release>
      break;
    }
  }
}
    800034a8:	60e2                	ld	ra,24(sp)
    800034aa:	6442                	ld	s0,16(sp)
    800034ac:	64a2                	ld	s1,8(sp)
    800034ae:	6902                	ld	s2,0(sp)
    800034b0:	6105                	addi	sp,sp,32
    800034b2:	8082                	ret

00000000800034b4 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800034b4:	7139                	addi	sp,sp,-64
    800034b6:	fc06                	sd	ra,56(sp)
    800034b8:	f822                	sd	s0,48(sp)
    800034ba:	f426                	sd	s1,40(sp)
    800034bc:	f04a                	sd	s2,32(sp)
    800034be:	ec4e                	sd	s3,24(sp)
    800034c0:	e852                	sd	s4,16(sp)
    800034c2:	e456                	sd	s5,8(sp)
    800034c4:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800034c6:	00016497          	auipc	s1,0x16
    800034ca:	b5a48493          	addi	s1,s1,-1190 # 80019020 <log>
    800034ce:	8526                	mv	a0,s1
    800034d0:	00003097          	auipc	ra,0x3
    800034d4:	b40080e7          	jalr	-1216(ra) # 80006010 <acquire>
  log.outstanding -= 1;
    800034d8:	509c                	lw	a5,32(s1)
    800034da:	37fd                	addiw	a5,a5,-1
    800034dc:	0007891b          	sext.w	s2,a5
    800034e0:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800034e2:	50dc                	lw	a5,36(s1)
    800034e4:	e7b9                	bnez	a5,80003532 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800034e6:	04091e63          	bnez	s2,80003542 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800034ea:	00016497          	auipc	s1,0x16
    800034ee:	b3648493          	addi	s1,s1,-1226 # 80019020 <log>
    800034f2:	4785                	li	a5,1
    800034f4:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800034f6:	8526                	mv	a0,s1
    800034f8:	00003097          	auipc	ra,0x3
    800034fc:	bcc080e7          	jalr	-1076(ra) # 800060c4 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003500:	54dc                	lw	a5,44(s1)
    80003502:	06f04763          	bgtz	a5,80003570 <end_op+0xbc>
    acquire(&log.lock);
    80003506:	00016497          	auipc	s1,0x16
    8000350a:	b1a48493          	addi	s1,s1,-1254 # 80019020 <log>
    8000350e:	8526                	mv	a0,s1
    80003510:	00003097          	auipc	ra,0x3
    80003514:	b00080e7          	jalr	-1280(ra) # 80006010 <acquire>
    log.committing = 0;
    80003518:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000351c:	8526                	mv	a0,s1
    8000351e:	ffffe097          	auipc	ra,0xffffe
    80003522:	170080e7          	jalr	368(ra) # 8000168e <wakeup>
    release(&log.lock);
    80003526:	8526                	mv	a0,s1
    80003528:	00003097          	auipc	ra,0x3
    8000352c:	b9c080e7          	jalr	-1124(ra) # 800060c4 <release>
}
    80003530:	a03d                	j	8000355e <end_op+0xaa>
    panic("log.committing");
    80003532:	00005517          	auipc	a0,0x5
    80003536:	07650513          	addi	a0,a0,118 # 800085a8 <syscalls+0x1e0>
    8000353a:	00002097          	auipc	ra,0x2
    8000353e:	59a080e7          	jalr	1434(ra) # 80005ad4 <panic>
    wakeup(&log);
    80003542:	00016497          	auipc	s1,0x16
    80003546:	ade48493          	addi	s1,s1,-1314 # 80019020 <log>
    8000354a:	8526                	mv	a0,s1
    8000354c:	ffffe097          	auipc	ra,0xffffe
    80003550:	142080e7          	jalr	322(ra) # 8000168e <wakeup>
  release(&log.lock);
    80003554:	8526                	mv	a0,s1
    80003556:	00003097          	auipc	ra,0x3
    8000355a:	b6e080e7          	jalr	-1170(ra) # 800060c4 <release>
}
    8000355e:	70e2                	ld	ra,56(sp)
    80003560:	7442                	ld	s0,48(sp)
    80003562:	74a2                	ld	s1,40(sp)
    80003564:	7902                	ld	s2,32(sp)
    80003566:	69e2                	ld	s3,24(sp)
    80003568:	6a42                	ld	s4,16(sp)
    8000356a:	6aa2                	ld	s5,8(sp)
    8000356c:	6121                	addi	sp,sp,64
    8000356e:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003570:	00016a97          	auipc	s5,0x16
    80003574:	ae0a8a93          	addi	s5,s5,-1312 # 80019050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003578:	00016a17          	auipc	s4,0x16
    8000357c:	aa8a0a13          	addi	s4,s4,-1368 # 80019020 <log>
    80003580:	018a2583          	lw	a1,24(s4)
    80003584:	012585bb          	addw	a1,a1,s2
    80003588:	2585                	addiw	a1,a1,1
    8000358a:	028a2503          	lw	a0,40(s4)
    8000358e:	fffff097          	auipc	ra,0xfffff
    80003592:	cd2080e7          	jalr	-814(ra) # 80002260 <bread>
    80003596:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003598:	000aa583          	lw	a1,0(s5)
    8000359c:	028a2503          	lw	a0,40(s4)
    800035a0:	fffff097          	auipc	ra,0xfffff
    800035a4:	cc0080e7          	jalr	-832(ra) # 80002260 <bread>
    800035a8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800035aa:	40000613          	li	a2,1024
    800035ae:	05850593          	addi	a1,a0,88
    800035b2:	05848513          	addi	a0,s1,88
    800035b6:	ffffd097          	auipc	ra,0xffffd
    800035ba:	c1e080e7          	jalr	-994(ra) # 800001d4 <memmove>
    bwrite(to);  // write the log
    800035be:	8526                	mv	a0,s1
    800035c0:	fffff097          	auipc	ra,0xfffff
    800035c4:	d92080e7          	jalr	-622(ra) # 80002352 <bwrite>
    brelse(from);
    800035c8:	854e                	mv	a0,s3
    800035ca:	fffff097          	auipc	ra,0xfffff
    800035ce:	dc6080e7          	jalr	-570(ra) # 80002390 <brelse>
    brelse(to);
    800035d2:	8526                	mv	a0,s1
    800035d4:	fffff097          	auipc	ra,0xfffff
    800035d8:	dbc080e7          	jalr	-580(ra) # 80002390 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035dc:	2905                	addiw	s2,s2,1
    800035de:	0a91                	addi	s5,s5,4
    800035e0:	02ca2783          	lw	a5,44(s4)
    800035e4:	f8f94ee3          	blt	s2,a5,80003580 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800035e8:	00000097          	auipc	ra,0x0
    800035ec:	c6a080e7          	jalr	-918(ra) # 80003252 <write_head>
    install_trans(0); // Now install writes to home locations
    800035f0:	4501                	li	a0,0
    800035f2:	00000097          	auipc	ra,0x0
    800035f6:	cda080e7          	jalr	-806(ra) # 800032cc <install_trans>
    log.lh.n = 0;
    800035fa:	00016797          	auipc	a5,0x16
    800035fe:	a407a923          	sw	zero,-1454(a5) # 8001904c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003602:	00000097          	auipc	ra,0x0
    80003606:	c50080e7          	jalr	-944(ra) # 80003252 <write_head>
    8000360a:	bdf5                	j	80003506 <end_op+0x52>

000000008000360c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000360c:	1101                	addi	sp,sp,-32
    8000360e:	ec06                	sd	ra,24(sp)
    80003610:	e822                	sd	s0,16(sp)
    80003612:	e426                	sd	s1,8(sp)
    80003614:	e04a                	sd	s2,0(sp)
    80003616:	1000                	addi	s0,sp,32
    80003618:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000361a:	00016917          	auipc	s2,0x16
    8000361e:	a0690913          	addi	s2,s2,-1530 # 80019020 <log>
    80003622:	854a                	mv	a0,s2
    80003624:	00003097          	auipc	ra,0x3
    80003628:	9ec080e7          	jalr	-1556(ra) # 80006010 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000362c:	02c92603          	lw	a2,44(s2)
    80003630:	47f5                	li	a5,29
    80003632:	06c7c563          	blt	a5,a2,8000369c <log_write+0x90>
    80003636:	00016797          	auipc	a5,0x16
    8000363a:	a067a783          	lw	a5,-1530(a5) # 8001903c <log+0x1c>
    8000363e:	37fd                	addiw	a5,a5,-1
    80003640:	04f65e63          	bge	a2,a5,8000369c <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003644:	00016797          	auipc	a5,0x16
    80003648:	9fc7a783          	lw	a5,-1540(a5) # 80019040 <log+0x20>
    8000364c:	06f05063          	blez	a5,800036ac <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003650:	4781                	li	a5,0
    80003652:	06c05563          	blez	a2,800036bc <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003656:	44cc                	lw	a1,12(s1)
    80003658:	00016717          	auipc	a4,0x16
    8000365c:	9f870713          	addi	a4,a4,-1544 # 80019050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003660:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003662:	4314                	lw	a3,0(a4)
    80003664:	04b68c63          	beq	a3,a1,800036bc <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003668:	2785                	addiw	a5,a5,1
    8000366a:	0711                	addi	a4,a4,4
    8000366c:	fef61be3          	bne	a2,a5,80003662 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003670:	0621                	addi	a2,a2,8
    80003672:	060a                	slli	a2,a2,0x2
    80003674:	00016797          	auipc	a5,0x16
    80003678:	9ac78793          	addi	a5,a5,-1620 # 80019020 <log>
    8000367c:	963e                	add	a2,a2,a5
    8000367e:	44dc                	lw	a5,12(s1)
    80003680:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003682:	8526                	mv	a0,s1
    80003684:	fffff097          	auipc	ra,0xfffff
    80003688:	daa080e7          	jalr	-598(ra) # 8000242e <bpin>
    log.lh.n++;
    8000368c:	00016717          	auipc	a4,0x16
    80003690:	99470713          	addi	a4,a4,-1644 # 80019020 <log>
    80003694:	575c                	lw	a5,44(a4)
    80003696:	2785                	addiw	a5,a5,1
    80003698:	d75c                	sw	a5,44(a4)
    8000369a:	a835                	j	800036d6 <log_write+0xca>
    panic("too big a transaction");
    8000369c:	00005517          	auipc	a0,0x5
    800036a0:	f1c50513          	addi	a0,a0,-228 # 800085b8 <syscalls+0x1f0>
    800036a4:	00002097          	auipc	ra,0x2
    800036a8:	430080e7          	jalr	1072(ra) # 80005ad4 <panic>
    panic("log_write outside of trans");
    800036ac:	00005517          	auipc	a0,0x5
    800036b0:	f2450513          	addi	a0,a0,-220 # 800085d0 <syscalls+0x208>
    800036b4:	00002097          	auipc	ra,0x2
    800036b8:	420080e7          	jalr	1056(ra) # 80005ad4 <panic>
  log.lh.block[i] = b->blockno;
    800036bc:	00878713          	addi	a4,a5,8
    800036c0:	00271693          	slli	a3,a4,0x2
    800036c4:	00016717          	auipc	a4,0x16
    800036c8:	95c70713          	addi	a4,a4,-1700 # 80019020 <log>
    800036cc:	9736                	add	a4,a4,a3
    800036ce:	44d4                	lw	a3,12(s1)
    800036d0:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800036d2:	faf608e3          	beq	a2,a5,80003682 <log_write+0x76>
  }
  release(&log.lock);
    800036d6:	00016517          	auipc	a0,0x16
    800036da:	94a50513          	addi	a0,a0,-1718 # 80019020 <log>
    800036de:	00003097          	auipc	ra,0x3
    800036e2:	9e6080e7          	jalr	-1562(ra) # 800060c4 <release>
}
    800036e6:	60e2                	ld	ra,24(sp)
    800036e8:	6442                	ld	s0,16(sp)
    800036ea:	64a2                	ld	s1,8(sp)
    800036ec:	6902                	ld	s2,0(sp)
    800036ee:	6105                	addi	sp,sp,32
    800036f0:	8082                	ret

00000000800036f2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800036f2:	1101                	addi	sp,sp,-32
    800036f4:	ec06                	sd	ra,24(sp)
    800036f6:	e822                	sd	s0,16(sp)
    800036f8:	e426                	sd	s1,8(sp)
    800036fa:	e04a                	sd	s2,0(sp)
    800036fc:	1000                	addi	s0,sp,32
    800036fe:	84aa                	mv	s1,a0
    80003700:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003702:	00005597          	auipc	a1,0x5
    80003706:	eee58593          	addi	a1,a1,-274 # 800085f0 <syscalls+0x228>
    8000370a:	0521                	addi	a0,a0,8
    8000370c:	00003097          	auipc	ra,0x3
    80003710:	874080e7          	jalr	-1932(ra) # 80005f80 <initlock>
  lk->name = name;
    80003714:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003718:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000371c:	0204a423          	sw	zero,40(s1)
}
    80003720:	60e2                	ld	ra,24(sp)
    80003722:	6442                	ld	s0,16(sp)
    80003724:	64a2                	ld	s1,8(sp)
    80003726:	6902                	ld	s2,0(sp)
    80003728:	6105                	addi	sp,sp,32
    8000372a:	8082                	ret

000000008000372c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000372c:	1101                	addi	sp,sp,-32
    8000372e:	ec06                	sd	ra,24(sp)
    80003730:	e822                	sd	s0,16(sp)
    80003732:	e426                	sd	s1,8(sp)
    80003734:	e04a                	sd	s2,0(sp)
    80003736:	1000                	addi	s0,sp,32
    80003738:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000373a:	00850913          	addi	s2,a0,8
    8000373e:	854a                	mv	a0,s2
    80003740:	00003097          	auipc	ra,0x3
    80003744:	8d0080e7          	jalr	-1840(ra) # 80006010 <acquire>
  while (lk->locked) {
    80003748:	409c                	lw	a5,0(s1)
    8000374a:	cb89                	beqz	a5,8000375c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000374c:	85ca                	mv	a1,s2
    8000374e:	8526                	mv	a0,s1
    80003750:	ffffe097          	auipc	ra,0xffffe
    80003754:	db2080e7          	jalr	-590(ra) # 80001502 <sleep>
  while (lk->locked) {
    80003758:	409c                	lw	a5,0(s1)
    8000375a:	fbed                	bnez	a5,8000374c <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000375c:	4785                	li	a5,1
    8000375e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003760:	ffffd097          	auipc	ra,0xffffd
    80003764:	6e2080e7          	jalr	1762(ra) # 80000e42 <myproc>
    80003768:	591c                	lw	a5,48(a0)
    8000376a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000376c:	854a                	mv	a0,s2
    8000376e:	00003097          	auipc	ra,0x3
    80003772:	956080e7          	jalr	-1706(ra) # 800060c4 <release>
}
    80003776:	60e2                	ld	ra,24(sp)
    80003778:	6442                	ld	s0,16(sp)
    8000377a:	64a2                	ld	s1,8(sp)
    8000377c:	6902                	ld	s2,0(sp)
    8000377e:	6105                	addi	sp,sp,32
    80003780:	8082                	ret

0000000080003782 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003782:	1101                	addi	sp,sp,-32
    80003784:	ec06                	sd	ra,24(sp)
    80003786:	e822                	sd	s0,16(sp)
    80003788:	e426                	sd	s1,8(sp)
    8000378a:	e04a                	sd	s2,0(sp)
    8000378c:	1000                	addi	s0,sp,32
    8000378e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003790:	00850913          	addi	s2,a0,8
    80003794:	854a                	mv	a0,s2
    80003796:	00003097          	auipc	ra,0x3
    8000379a:	87a080e7          	jalr	-1926(ra) # 80006010 <acquire>
  lk->locked = 0;
    8000379e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800037a2:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800037a6:	8526                	mv	a0,s1
    800037a8:	ffffe097          	auipc	ra,0xffffe
    800037ac:	ee6080e7          	jalr	-282(ra) # 8000168e <wakeup>
  release(&lk->lk);
    800037b0:	854a                	mv	a0,s2
    800037b2:	00003097          	auipc	ra,0x3
    800037b6:	912080e7          	jalr	-1774(ra) # 800060c4 <release>
}
    800037ba:	60e2                	ld	ra,24(sp)
    800037bc:	6442                	ld	s0,16(sp)
    800037be:	64a2                	ld	s1,8(sp)
    800037c0:	6902                	ld	s2,0(sp)
    800037c2:	6105                	addi	sp,sp,32
    800037c4:	8082                	ret

00000000800037c6 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800037c6:	7179                	addi	sp,sp,-48
    800037c8:	f406                	sd	ra,40(sp)
    800037ca:	f022                	sd	s0,32(sp)
    800037cc:	ec26                	sd	s1,24(sp)
    800037ce:	e84a                	sd	s2,16(sp)
    800037d0:	e44e                	sd	s3,8(sp)
    800037d2:	1800                	addi	s0,sp,48
    800037d4:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800037d6:	00850913          	addi	s2,a0,8
    800037da:	854a                	mv	a0,s2
    800037dc:	00003097          	auipc	ra,0x3
    800037e0:	834080e7          	jalr	-1996(ra) # 80006010 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800037e4:	409c                	lw	a5,0(s1)
    800037e6:	ef99                	bnez	a5,80003804 <holdingsleep+0x3e>
    800037e8:	4481                	li	s1,0
  release(&lk->lk);
    800037ea:	854a                	mv	a0,s2
    800037ec:	00003097          	auipc	ra,0x3
    800037f0:	8d8080e7          	jalr	-1832(ra) # 800060c4 <release>
  return r;
}
    800037f4:	8526                	mv	a0,s1
    800037f6:	70a2                	ld	ra,40(sp)
    800037f8:	7402                	ld	s0,32(sp)
    800037fa:	64e2                	ld	s1,24(sp)
    800037fc:	6942                	ld	s2,16(sp)
    800037fe:	69a2                	ld	s3,8(sp)
    80003800:	6145                	addi	sp,sp,48
    80003802:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003804:	0284a983          	lw	s3,40(s1)
    80003808:	ffffd097          	auipc	ra,0xffffd
    8000380c:	63a080e7          	jalr	1594(ra) # 80000e42 <myproc>
    80003810:	5904                	lw	s1,48(a0)
    80003812:	413484b3          	sub	s1,s1,s3
    80003816:	0014b493          	seqz	s1,s1
    8000381a:	bfc1                	j	800037ea <holdingsleep+0x24>

000000008000381c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000381c:	1141                	addi	sp,sp,-16
    8000381e:	e406                	sd	ra,8(sp)
    80003820:	e022                	sd	s0,0(sp)
    80003822:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003824:	00005597          	auipc	a1,0x5
    80003828:	ddc58593          	addi	a1,a1,-548 # 80008600 <syscalls+0x238>
    8000382c:	00016517          	auipc	a0,0x16
    80003830:	93c50513          	addi	a0,a0,-1732 # 80019168 <ftable>
    80003834:	00002097          	auipc	ra,0x2
    80003838:	74c080e7          	jalr	1868(ra) # 80005f80 <initlock>
}
    8000383c:	60a2                	ld	ra,8(sp)
    8000383e:	6402                	ld	s0,0(sp)
    80003840:	0141                	addi	sp,sp,16
    80003842:	8082                	ret

0000000080003844 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003844:	1101                	addi	sp,sp,-32
    80003846:	ec06                	sd	ra,24(sp)
    80003848:	e822                	sd	s0,16(sp)
    8000384a:	e426                	sd	s1,8(sp)
    8000384c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000384e:	00016517          	auipc	a0,0x16
    80003852:	91a50513          	addi	a0,a0,-1766 # 80019168 <ftable>
    80003856:	00002097          	auipc	ra,0x2
    8000385a:	7ba080e7          	jalr	1978(ra) # 80006010 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000385e:	00016497          	auipc	s1,0x16
    80003862:	92248493          	addi	s1,s1,-1758 # 80019180 <ftable+0x18>
    80003866:	00017717          	auipc	a4,0x17
    8000386a:	8ba70713          	addi	a4,a4,-1862 # 8001a120 <ftable+0xfb8>
    if(f->ref == 0){
    8000386e:	40dc                	lw	a5,4(s1)
    80003870:	cf99                	beqz	a5,8000388e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003872:	02848493          	addi	s1,s1,40
    80003876:	fee49ce3          	bne	s1,a4,8000386e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000387a:	00016517          	auipc	a0,0x16
    8000387e:	8ee50513          	addi	a0,a0,-1810 # 80019168 <ftable>
    80003882:	00003097          	auipc	ra,0x3
    80003886:	842080e7          	jalr	-1982(ra) # 800060c4 <release>
  return 0;
    8000388a:	4481                	li	s1,0
    8000388c:	a819                	j	800038a2 <filealloc+0x5e>
      f->ref = 1;
    8000388e:	4785                	li	a5,1
    80003890:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003892:	00016517          	auipc	a0,0x16
    80003896:	8d650513          	addi	a0,a0,-1834 # 80019168 <ftable>
    8000389a:	00003097          	auipc	ra,0x3
    8000389e:	82a080e7          	jalr	-2006(ra) # 800060c4 <release>
}
    800038a2:	8526                	mv	a0,s1
    800038a4:	60e2                	ld	ra,24(sp)
    800038a6:	6442                	ld	s0,16(sp)
    800038a8:	64a2                	ld	s1,8(sp)
    800038aa:	6105                	addi	sp,sp,32
    800038ac:	8082                	ret

00000000800038ae <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800038ae:	1101                	addi	sp,sp,-32
    800038b0:	ec06                	sd	ra,24(sp)
    800038b2:	e822                	sd	s0,16(sp)
    800038b4:	e426                	sd	s1,8(sp)
    800038b6:	1000                	addi	s0,sp,32
    800038b8:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800038ba:	00016517          	auipc	a0,0x16
    800038be:	8ae50513          	addi	a0,a0,-1874 # 80019168 <ftable>
    800038c2:	00002097          	auipc	ra,0x2
    800038c6:	74e080e7          	jalr	1870(ra) # 80006010 <acquire>
  if(f->ref < 1)
    800038ca:	40dc                	lw	a5,4(s1)
    800038cc:	02f05263          	blez	a5,800038f0 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800038d0:	2785                	addiw	a5,a5,1
    800038d2:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800038d4:	00016517          	auipc	a0,0x16
    800038d8:	89450513          	addi	a0,a0,-1900 # 80019168 <ftable>
    800038dc:	00002097          	auipc	ra,0x2
    800038e0:	7e8080e7          	jalr	2024(ra) # 800060c4 <release>
  return f;
}
    800038e4:	8526                	mv	a0,s1
    800038e6:	60e2                	ld	ra,24(sp)
    800038e8:	6442                	ld	s0,16(sp)
    800038ea:	64a2                	ld	s1,8(sp)
    800038ec:	6105                	addi	sp,sp,32
    800038ee:	8082                	ret
    panic("filedup");
    800038f0:	00005517          	auipc	a0,0x5
    800038f4:	d1850513          	addi	a0,a0,-744 # 80008608 <syscalls+0x240>
    800038f8:	00002097          	auipc	ra,0x2
    800038fc:	1dc080e7          	jalr	476(ra) # 80005ad4 <panic>

0000000080003900 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003900:	7139                	addi	sp,sp,-64
    80003902:	fc06                	sd	ra,56(sp)
    80003904:	f822                	sd	s0,48(sp)
    80003906:	f426                	sd	s1,40(sp)
    80003908:	f04a                	sd	s2,32(sp)
    8000390a:	ec4e                	sd	s3,24(sp)
    8000390c:	e852                	sd	s4,16(sp)
    8000390e:	e456                	sd	s5,8(sp)
    80003910:	0080                	addi	s0,sp,64
    80003912:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003914:	00016517          	auipc	a0,0x16
    80003918:	85450513          	addi	a0,a0,-1964 # 80019168 <ftable>
    8000391c:	00002097          	auipc	ra,0x2
    80003920:	6f4080e7          	jalr	1780(ra) # 80006010 <acquire>
  if(f->ref < 1)
    80003924:	40dc                	lw	a5,4(s1)
    80003926:	06f05163          	blez	a5,80003988 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    8000392a:	37fd                	addiw	a5,a5,-1
    8000392c:	0007871b          	sext.w	a4,a5
    80003930:	c0dc                	sw	a5,4(s1)
    80003932:	06e04363          	bgtz	a4,80003998 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003936:	0004a903          	lw	s2,0(s1)
    8000393a:	0094ca83          	lbu	s5,9(s1)
    8000393e:	0104ba03          	ld	s4,16(s1)
    80003942:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003946:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000394a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000394e:	00016517          	auipc	a0,0x16
    80003952:	81a50513          	addi	a0,a0,-2022 # 80019168 <ftable>
    80003956:	00002097          	auipc	ra,0x2
    8000395a:	76e080e7          	jalr	1902(ra) # 800060c4 <release>

  if(ff.type == FD_PIPE){
    8000395e:	4785                	li	a5,1
    80003960:	04f90d63          	beq	s2,a5,800039ba <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003964:	3979                	addiw	s2,s2,-2
    80003966:	4785                	li	a5,1
    80003968:	0527e063          	bltu	a5,s2,800039a8 <fileclose+0xa8>
    begin_op();
    8000396c:	00000097          	auipc	ra,0x0
    80003970:	ac8080e7          	jalr	-1336(ra) # 80003434 <begin_op>
    iput(ff.ip);
    80003974:	854e                	mv	a0,s3
    80003976:	fffff097          	auipc	ra,0xfffff
    8000397a:	2a6080e7          	jalr	678(ra) # 80002c1c <iput>
    end_op();
    8000397e:	00000097          	auipc	ra,0x0
    80003982:	b36080e7          	jalr	-1226(ra) # 800034b4 <end_op>
    80003986:	a00d                	j	800039a8 <fileclose+0xa8>
    panic("fileclose");
    80003988:	00005517          	auipc	a0,0x5
    8000398c:	c8850513          	addi	a0,a0,-888 # 80008610 <syscalls+0x248>
    80003990:	00002097          	auipc	ra,0x2
    80003994:	144080e7          	jalr	324(ra) # 80005ad4 <panic>
    release(&ftable.lock);
    80003998:	00015517          	auipc	a0,0x15
    8000399c:	7d050513          	addi	a0,a0,2000 # 80019168 <ftable>
    800039a0:	00002097          	auipc	ra,0x2
    800039a4:	724080e7          	jalr	1828(ra) # 800060c4 <release>
  }
}
    800039a8:	70e2                	ld	ra,56(sp)
    800039aa:	7442                	ld	s0,48(sp)
    800039ac:	74a2                	ld	s1,40(sp)
    800039ae:	7902                	ld	s2,32(sp)
    800039b0:	69e2                	ld	s3,24(sp)
    800039b2:	6a42                	ld	s4,16(sp)
    800039b4:	6aa2                	ld	s5,8(sp)
    800039b6:	6121                	addi	sp,sp,64
    800039b8:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800039ba:	85d6                	mv	a1,s5
    800039bc:	8552                	mv	a0,s4
    800039be:	00000097          	auipc	ra,0x0
    800039c2:	34c080e7          	jalr	844(ra) # 80003d0a <pipeclose>
    800039c6:	b7cd                	j	800039a8 <fileclose+0xa8>

00000000800039c8 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800039c8:	715d                	addi	sp,sp,-80
    800039ca:	e486                	sd	ra,72(sp)
    800039cc:	e0a2                	sd	s0,64(sp)
    800039ce:	fc26                	sd	s1,56(sp)
    800039d0:	f84a                	sd	s2,48(sp)
    800039d2:	f44e                	sd	s3,40(sp)
    800039d4:	0880                	addi	s0,sp,80
    800039d6:	84aa                	mv	s1,a0
    800039d8:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800039da:	ffffd097          	auipc	ra,0xffffd
    800039de:	468080e7          	jalr	1128(ra) # 80000e42 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800039e2:	409c                	lw	a5,0(s1)
    800039e4:	37f9                	addiw	a5,a5,-2
    800039e6:	4705                	li	a4,1
    800039e8:	04f76763          	bltu	a4,a5,80003a36 <filestat+0x6e>
    800039ec:	892a                	mv	s2,a0
    ilock(f->ip);
    800039ee:	6c88                	ld	a0,24(s1)
    800039f0:	fffff097          	auipc	ra,0xfffff
    800039f4:	072080e7          	jalr	114(ra) # 80002a62 <ilock>
    stati(f->ip, &st);
    800039f8:	fb840593          	addi	a1,s0,-72
    800039fc:	6c88                	ld	a0,24(s1)
    800039fe:	fffff097          	auipc	ra,0xfffff
    80003a02:	2ee080e7          	jalr	750(ra) # 80002cec <stati>
    iunlock(f->ip);
    80003a06:	6c88                	ld	a0,24(s1)
    80003a08:	fffff097          	auipc	ra,0xfffff
    80003a0c:	11c080e7          	jalr	284(ra) # 80002b24 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003a10:	46e1                	li	a3,24
    80003a12:	fb840613          	addi	a2,s0,-72
    80003a16:	85ce                	mv	a1,s3
    80003a18:	05093503          	ld	a0,80(s2)
    80003a1c:	ffffd097          	auipc	ra,0xffffd
    80003a20:	0e6080e7          	jalr	230(ra) # 80000b02 <copyout>
    80003a24:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003a28:	60a6                	ld	ra,72(sp)
    80003a2a:	6406                	ld	s0,64(sp)
    80003a2c:	74e2                	ld	s1,56(sp)
    80003a2e:	7942                	ld	s2,48(sp)
    80003a30:	79a2                	ld	s3,40(sp)
    80003a32:	6161                	addi	sp,sp,80
    80003a34:	8082                	ret
  return -1;
    80003a36:	557d                	li	a0,-1
    80003a38:	bfc5                	j	80003a28 <filestat+0x60>

0000000080003a3a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003a3a:	7179                	addi	sp,sp,-48
    80003a3c:	f406                	sd	ra,40(sp)
    80003a3e:	f022                	sd	s0,32(sp)
    80003a40:	ec26                	sd	s1,24(sp)
    80003a42:	e84a                	sd	s2,16(sp)
    80003a44:	e44e                	sd	s3,8(sp)
    80003a46:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003a48:	00854783          	lbu	a5,8(a0)
    80003a4c:	c3d5                	beqz	a5,80003af0 <fileread+0xb6>
    80003a4e:	84aa                	mv	s1,a0
    80003a50:	89ae                	mv	s3,a1
    80003a52:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003a54:	411c                	lw	a5,0(a0)
    80003a56:	4705                	li	a4,1
    80003a58:	04e78963          	beq	a5,a4,80003aaa <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003a5c:	470d                	li	a4,3
    80003a5e:	04e78d63          	beq	a5,a4,80003ab8 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003a62:	4709                	li	a4,2
    80003a64:	06e79e63          	bne	a5,a4,80003ae0 <fileread+0xa6>
    ilock(f->ip);
    80003a68:	6d08                	ld	a0,24(a0)
    80003a6a:	fffff097          	auipc	ra,0xfffff
    80003a6e:	ff8080e7          	jalr	-8(ra) # 80002a62 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003a72:	874a                	mv	a4,s2
    80003a74:	5094                	lw	a3,32(s1)
    80003a76:	864e                	mv	a2,s3
    80003a78:	4585                	li	a1,1
    80003a7a:	6c88                	ld	a0,24(s1)
    80003a7c:	fffff097          	auipc	ra,0xfffff
    80003a80:	29a080e7          	jalr	666(ra) # 80002d16 <readi>
    80003a84:	892a                	mv	s2,a0
    80003a86:	00a05563          	blez	a0,80003a90 <fileread+0x56>
      f->off += r;
    80003a8a:	509c                	lw	a5,32(s1)
    80003a8c:	9fa9                	addw	a5,a5,a0
    80003a8e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003a90:	6c88                	ld	a0,24(s1)
    80003a92:	fffff097          	auipc	ra,0xfffff
    80003a96:	092080e7          	jalr	146(ra) # 80002b24 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003a9a:	854a                	mv	a0,s2
    80003a9c:	70a2                	ld	ra,40(sp)
    80003a9e:	7402                	ld	s0,32(sp)
    80003aa0:	64e2                	ld	s1,24(sp)
    80003aa2:	6942                	ld	s2,16(sp)
    80003aa4:	69a2                	ld	s3,8(sp)
    80003aa6:	6145                	addi	sp,sp,48
    80003aa8:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003aaa:	6908                	ld	a0,16(a0)
    80003aac:	00000097          	auipc	ra,0x0
    80003ab0:	3c0080e7          	jalr	960(ra) # 80003e6c <piperead>
    80003ab4:	892a                	mv	s2,a0
    80003ab6:	b7d5                	j	80003a9a <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003ab8:	02451783          	lh	a5,36(a0)
    80003abc:	03079693          	slli	a3,a5,0x30
    80003ac0:	92c1                	srli	a3,a3,0x30
    80003ac2:	4725                	li	a4,9
    80003ac4:	02d76863          	bltu	a4,a3,80003af4 <fileread+0xba>
    80003ac8:	0792                	slli	a5,a5,0x4
    80003aca:	00015717          	auipc	a4,0x15
    80003ace:	5fe70713          	addi	a4,a4,1534 # 800190c8 <devsw>
    80003ad2:	97ba                	add	a5,a5,a4
    80003ad4:	639c                	ld	a5,0(a5)
    80003ad6:	c38d                	beqz	a5,80003af8 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003ad8:	4505                	li	a0,1
    80003ada:	9782                	jalr	a5
    80003adc:	892a                	mv	s2,a0
    80003ade:	bf75                	j	80003a9a <fileread+0x60>
    panic("fileread");
    80003ae0:	00005517          	auipc	a0,0x5
    80003ae4:	b4050513          	addi	a0,a0,-1216 # 80008620 <syscalls+0x258>
    80003ae8:	00002097          	auipc	ra,0x2
    80003aec:	fec080e7          	jalr	-20(ra) # 80005ad4 <panic>
    return -1;
    80003af0:	597d                	li	s2,-1
    80003af2:	b765                	j	80003a9a <fileread+0x60>
      return -1;
    80003af4:	597d                	li	s2,-1
    80003af6:	b755                	j	80003a9a <fileread+0x60>
    80003af8:	597d                	li	s2,-1
    80003afa:	b745                	j	80003a9a <fileread+0x60>

0000000080003afc <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003afc:	715d                	addi	sp,sp,-80
    80003afe:	e486                	sd	ra,72(sp)
    80003b00:	e0a2                	sd	s0,64(sp)
    80003b02:	fc26                	sd	s1,56(sp)
    80003b04:	f84a                	sd	s2,48(sp)
    80003b06:	f44e                	sd	s3,40(sp)
    80003b08:	f052                	sd	s4,32(sp)
    80003b0a:	ec56                	sd	s5,24(sp)
    80003b0c:	e85a                	sd	s6,16(sp)
    80003b0e:	e45e                	sd	s7,8(sp)
    80003b10:	e062                	sd	s8,0(sp)
    80003b12:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003b14:	00954783          	lbu	a5,9(a0)
    80003b18:	10078663          	beqz	a5,80003c24 <filewrite+0x128>
    80003b1c:	892a                	mv	s2,a0
    80003b1e:	8aae                	mv	s5,a1
    80003b20:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b22:	411c                	lw	a5,0(a0)
    80003b24:	4705                	li	a4,1
    80003b26:	02e78263          	beq	a5,a4,80003b4a <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b2a:	470d                	li	a4,3
    80003b2c:	02e78663          	beq	a5,a4,80003b58 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b30:	4709                	li	a4,2
    80003b32:	0ee79163          	bne	a5,a4,80003c14 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003b36:	0ac05d63          	blez	a2,80003bf0 <filewrite+0xf4>
    int i = 0;
    80003b3a:	4981                	li	s3,0
    80003b3c:	6b05                	lui	s6,0x1
    80003b3e:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003b42:	6b85                	lui	s7,0x1
    80003b44:	c00b8b9b          	addiw	s7,s7,-1024
    80003b48:	a861                	j	80003be0 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003b4a:	6908                	ld	a0,16(a0)
    80003b4c:	00000097          	auipc	ra,0x0
    80003b50:	22e080e7          	jalr	558(ra) # 80003d7a <pipewrite>
    80003b54:	8a2a                	mv	s4,a0
    80003b56:	a045                	j	80003bf6 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003b58:	02451783          	lh	a5,36(a0)
    80003b5c:	03079693          	slli	a3,a5,0x30
    80003b60:	92c1                	srli	a3,a3,0x30
    80003b62:	4725                	li	a4,9
    80003b64:	0cd76263          	bltu	a4,a3,80003c28 <filewrite+0x12c>
    80003b68:	0792                	slli	a5,a5,0x4
    80003b6a:	00015717          	auipc	a4,0x15
    80003b6e:	55e70713          	addi	a4,a4,1374 # 800190c8 <devsw>
    80003b72:	97ba                	add	a5,a5,a4
    80003b74:	679c                	ld	a5,8(a5)
    80003b76:	cbdd                	beqz	a5,80003c2c <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003b78:	4505                	li	a0,1
    80003b7a:	9782                	jalr	a5
    80003b7c:	8a2a                	mv	s4,a0
    80003b7e:	a8a5                	j	80003bf6 <filewrite+0xfa>
    80003b80:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003b84:	00000097          	auipc	ra,0x0
    80003b88:	8b0080e7          	jalr	-1872(ra) # 80003434 <begin_op>
      ilock(f->ip);
    80003b8c:	01893503          	ld	a0,24(s2)
    80003b90:	fffff097          	auipc	ra,0xfffff
    80003b94:	ed2080e7          	jalr	-302(ra) # 80002a62 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003b98:	8762                	mv	a4,s8
    80003b9a:	02092683          	lw	a3,32(s2)
    80003b9e:	01598633          	add	a2,s3,s5
    80003ba2:	4585                	li	a1,1
    80003ba4:	01893503          	ld	a0,24(s2)
    80003ba8:	fffff097          	auipc	ra,0xfffff
    80003bac:	266080e7          	jalr	614(ra) # 80002e0e <writei>
    80003bb0:	84aa                	mv	s1,a0
    80003bb2:	00a05763          	blez	a0,80003bc0 <filewrite+0xc4>
        f->off += r;
    80003bb6:	02092783          	lw	a5,32(s2)
    80003bba:	9fa9                	addw	a5,a5,a0
    80003bbc:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003bc0:	01893503          	ld	a0,24(s2)
    80003bc4:	fffff097          	auipc	ra,0xfffff
    80003bc8:	f60080e7          	jalr	-160(ra) # 80002b24 <iunlock>
      end_op();
    80003bcc:	00000097          	auipc	ra,0x0
    80003bd0:	8e8080e7          	jalr	-1816(ra) # 800034b4 <end_op>

      if(r != n1){
    80003bd4:	009c1f63          	bne	s8,s1,80003bf2 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003bd8:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003bdc:	0149db63          	bge	s3,s4,80003bf2 <filewrite+0xf6>
      int n1 = n - i;
    80003be0:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003be4:	84be                	mv	s1,a5
    80003be6:	2781                	sext.w	a5,a5
    80003be8:	f8fb5ce3          	bge	s6,a5,80003b80 <filewrite+0x84>
    80003bec:	84de                	mv	s1,s7
    80003bee:	bf49                	j	80003b80 <filewrite+0x84>
    int i = 0;
    80003bf0:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003bf2:	013a1f63          	bne	s4,s3,80003c10 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003bf6:	8552                	mv	a0,s4
    80003bf8:	60a6                	ld	ra,72(sp)
    80003bfa:	6406                	ld	s0,64(sp)
    80003bfc:	74e2                	ld	s1,56(sp)
    80003bfe:	7942                	ld	s2,48(sp)
    80003c00:	79a2                	ld	s3,40(sp)
    80003c02:	7a02                	ld	s4,32(sp)
    80003c04:	6ae2                	ld	s5,24(sp)
    80003c06:	6b42                	ld	s6,16(sp)
    80003c08:	6ba2                	ld	s7,8(sp)
    80003c0a:	6c02                	ld	s8,0(sp)
    80003c0c:	6161                	addi	sp,sp,80
    80003c0e:	8082                	ret
    ret = (i == n ? n : -1);
    80003c10:	5a7d                	li	s4,-1
    80003c12:	b7d5                	j	80003bf6 <filewrite+0xfa>
    panic("filewrite");
    80003c14:	00005517          	auipc	a0,0x5
    80003c18:	a1c50513          	addi	a0,a0,-1508 # 80008630 <syscalls+0x268>
    80003c1c:	00002097          	auipc	ra,0x2
    80003c20:	eb8080e7          	jalr	-328(ra) # 80005ad4 <panic>
    return -1;
    80003c24:	5a7d                	li	s4,-1
    80003c26:	bfc1                	j	80003bf6 <filewrite+0xfa>
      return -1;
    80003c28:	5a7d                	li	s4,-1
    80003c2a:	b7f1                	j	80003bf6 <filewrite+0xfa>
    80003c2c:	5a7d                	li	s4,-1
    80003c2e:	b7e1                	j	80003bf6 <filewrite+0xfa>

0000000080003c30 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003c30:	7179                	addi	sp,sp,-48
    80003c32:	f406                	sd	ra,40(sp)
    80003c34:	f022                	sd	s0,32(sp)
    80003c36:	ec26                	sd	s1,24(sp)
    80003c38:	e84a                	sd	s2,16(sp)
    80003c3a:	e44e                	sd	s3,8(sp)
    80003c3c:	e052                	sd	s4,0(sp)
    80003c3e:	1800                	addi	s0,sp,48
    80003c40:	84aa                	mv	s1,a0
    80003c42:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003c44:	0005b023          	sd	zero,0(a1)
    80003c48:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003c4c:	00000097          	auipc	ra,0x0
    80003c50:	bf8080e7          	jalr	-1032(ra) # 80003844 <filealloc>
    80003c54:	e088                	sd	a0,0(s1)
    80003c56:	c551                	beqz	a0,80003ce2 <pipealloc+0xb2>
    80003c58:	00000097          	auipc	ra,0x0
    80003c5c:	bec080e7          	jalr	-1044(ra) # 80003844 <filealloc>
    80003c60:	00aa3023          	sd	a0,0(s4)
    80003c64:	c92d                	beqz	a0,80003cd6 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003c66:	ffffc097          	auipc	ra,0xffffc
    80003c6a:	4b2080e7          	jalr	1202(ra) # 80000118 <kalloc>
    80003c6e:	892a                	mv	s2,a0
    80003c70:	c125                	beqz	a0,80003cd0 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003c72:	4985                	li	s3,1
    80003c74:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003c78:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003c7c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003c80:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003c84:	00005597          	auipc	a1,0x5
    80003c88:	9bc58593          	addi	a1,a1,-1604 # 80008640 <syscalls+0x278>
    80003c8c:	00002097          	auipc	ra,0x2
    80003c90:	2f4080e7          	jalr	756(ra) # 80005f80 <initlock>
  (*f0)->type = FD_PIPE;
    80003c94:	609c                	ld	a5,0(s1)
    80003c96:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003c9a:	609c                	ld	a5,0(s1)
    80003c9c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003ca0:	609c                	ld	a5,0(s1)
    80003ca2:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003ca6:	609c                	ld	a5,0(s1)
    80003ca8:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003cac:	000a3783          	ld	a5,0(s4)
    80003cb0:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003cb4:	000a3783          	ld	a5,0(s4)
    80003cb8:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003cbc:	000a3783          	ld	a5,0(s4)
    80003cc0:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003cc4:	000a3783          	ld	a5,0(s4)
    80003cc8:	0127b823          	sd	s2,16(a5)
  return 0;
    80003ccc:	4501                	li	a0,0
    80003cce:	a025                	j	80003cf6 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003cd0:	6088                	ld	a0,0(s1)
    80003cd2:	e501                	bnez	a0,80003cda <pipealloc+0xaa>
    80003cd4:	a039                	j	80003ce2 <pipealloc+0xb2>
    80003cd6:	6088                	ld	a0,0(s1)
    80003cd8:	c51d                	beqz	a0,80003d06 <pipealloc+0xd6>
    fileclose(*f0);
    80003cda:	00000097          	auipc	ra,0x0
    80003cde:	c26080e7          	jalr	-986(ra) # 80003900 <fileclose>
  if(*f1)
    80003ce2:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003ce6:	557d                	li	a0,-1
  if(*f1)
    80003ce8:	c799                	beqz	a5,80003cf6 <pipealloc+0xc6>
    fileclose(*f1);
    80003cea:	853e                	mv	a0,a5
    80003cec:	00000097          	auipc	ra,0x0
    80003cf0:	c14080e7          	jalr	-1004(ra) # 80003900 <fileclose>
  return -1;
    80003cf4:	557d                	li	a0,-1
}
    80003cf6:	70a2                	ld	ra,40(sp)
    80003cf8:	7402                	ld	s0,32(sp)
    80003cfa:	64e2                	ld	s1,24(sp)
    80003cfc:	6942                	ld	s2,16(sp)
    80003cfe:	69a2                	ld	s3,8(sp)
    80003d00:	6a02                	ld	s4,0(sp)
    80003d02:	6145                	addi	sp,sp,48
    80003d04:	8082                	ret
  return -1;
    80003d06:	557d                	li	a0,-1
    80003d08:	b7fd                	j	80003cf6 <pipealloc+0xc6>

0000000080003d0a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003d0a:	1101                	addi	sp,sp,-32
    80003d0c:	ec06                	sd	ra,24(sp)
    80003d0e:	e822                	sd	s0,16(sp)
    80003d10:	e426                	sd	s1,8(sp)
    80003d12:	e04a                	sd	s2,0(sp)
    80003d14:	1000                	addi	s0,sp,32
    80003d16:	84aa                	mv	s1,a0
    80003d18:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003d1a:	00002097          	auipc	ra,0x2
    80003d1e:	2f6080e7          	jalr	758(ra) # 80006010 <acquire>
  if(writable){
    80003d22:	02090d63          	beqz	s2,80003d5c <pipeclose+0x52>
    pi->writeopen = 0;
    80003d26:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003d2a:	21848513          	addi	a0,s1,536
    80003d2e:	ffffe097          	auipc	ra,0xffffe
    80003d32:	960080e7          	jalr	-1696(ra) # 8000168e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003d36:	2204b783          	ld	a5,544(s1)
    80003d3a:	eb95                	bnez	a5,80003d6e <pipeclose+0x64>
    release(&pi->lock);
    80003d3c:	8526                	mv	a0,s1
    80003d3e:	00002097          	auipc	ra,0x2
    80003d42:	386080e7          	jalr	902(ra) # 800060c4 <release>
    kfree((char*)pi);
    80003d46:	8526                	mv	a0,s1
    80003d48:	ffffc097          	auipc	ra,0xffffc
    80003d4c:	2d4080e7          	jalr	724(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003d50:	60e2                	ld	ra,24(sp)
    80003d52:	6442                	ld	s0,16(sp)
    80003d54:	64a2                	ld	s1,8(sp)
    80003d56:	6902                	ld	s2,0(sp)
    80003d58:	6105                	addi	sp,sp,32
    80003d5a:	8082                	ret
    pi->readopen = 0;
    80003d5c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003d60:	21c48513          	addi	a0,s1,540
    80003d64:	ffffe097          	auipc	ra,0xffffe
    80003d68:	92a080e7          	jalr	-1750(ra) # 8000168e <wakeup>
    80003d6c:	b7e9                	j	80003d36 <pipeclose+0x2c>
    release(&pi->lock);
    80003d6e:	8526                	mv	a0,s1
    80003d70:	00002097          	auipc	ra,0x2
    80003d74:	354080e7          	jalr	852(ra) # 800060c4 <release>
}
    80003d78:	bfe1                	j	80003d50 <pipeclose+0x46>

0000000080003d7a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003d7a:	711d                	addi	sp,sp,-96
    80003d7c:	ec86                	sd	ra,88(sp)
    80003d7e:	e8a2                	sd	s0,80(sp)
    80003d80:	e4a6                	sd	s1,72(sp)
    80003d82:	e0ca                	sd	s2,64(sp)
    80003d84:	fc4e                	sd	s3,56(sp)
    80003d86:	f852                	sd	s4,48(sp)
    80003d88:	f456                	sd	s5,40(sp)
    80003d8a:	f05a                	sd	s6,32(sp)
    80003d8c:	ec5e                	sd	s7,24(sp)
    80003d8e:	e862                	sd	s8,16(sp)
    80003d90:	1080                	addi	s0,sp,96
    80003d92:	84aa                	mv	s1,a0
    80003d94:	8aae                	mv	s5,a1
    80003d96:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003d98:	ffffd097          	auipc	ra,0xffffd
    80003d9c:	0aa080e7          	jalr	170(ra) # 80000e42 <myproc>
    80003da0:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003da2:	8526                	mv	a0,s1
    80003da4:	00002097          	auipc	ra,0x2
    80003da8:	26c080e7          	jalr	620(ra) # 80006010 <acquire>
  while(i < n){
    80003dac:	0b405363          	blez	s4,80003e52 <pipewrite+0xd8>
  int i = 0;
    80003db0:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003db2:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003db4:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003db8:	21c48b93          	addi	s7,s1,540
    80003dbc:	a089                	j	80003dfe <pipewrite+0x84>
      release(&pi->lock);
    80003dbe:	8526                	mv	a0,s1
    80003dc0:	00002097          	auipc	ra,0x2
    80003dc4:	304080e7          	jalr	772(ra) # 800060c4 <release>
      return -1;
    80003dc8:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003dca:	854a                	mv	a0,s2
    80003dcc:	60e6                	ld	ra,88(sp)
    80003dce:	6446                	ld	s0,80(sp)
    80003dd0:	64a6                	ld	s1,72(sp)
    80003dd2:	6906                	ld	s2,64(sp)
    80003dd4:	79e2                	ld	s3,56(sp)
    80003dd6:	7a42                	ld	s4,48(sp)
    80003dd8:	7aa2                	ld	s5,40(sp)
    80003dda:	7b02                	ld	s6,32(sp)
    80003ddc:	6be2                	ld	s7,24(sp)
    80003dde:	6c42                	ld	s8,16(sp)
    80003de0:	6125                	addi	sp,sp,96
    80003de2:	8082                	ret
      wakeup(&pi->nread);
    80003de4:	8562                	mv	a0,s8
    80003de6:	ffffe097          	auipc	ra,0xffffe
    80003dea:	8a8080e7          	jalr	-1880(ra) # 8000168e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003dee:	85a6                	mv	a1,s1
    80003df0:	855e                	mv	a0,s7
    80003df2:	ffffd097          	auipc	ra,0xffffd
    80003df6:	710080e7          	jalr	1808(ra) # 80001502 <sleep>
  while(i < n){
    80003dfa:	05495d63          	bge	s2,s4,80003e54 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80003dfe:	2204a783          	lw	a5,544(s1)
    80003e02:	dfd5                	beqz	a5,80003dbe <pipewrite+0x44>
    80003e04:	0289a783          	lw	a5,40(s3)
    80003e08:	fbdd                	bnez	a5,80003dbe <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003e0a:	2184a783          	lw	a5,536(s1)
    80003e0e:	21c4a703          	lw	a4,540(s1)
    80003e12:	2007879b          	addiw	a5,a5,512
    80003e16:	fcf707e3          	beq	a4,a5,80003de4 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e1a:	4685                	li	a3,1
    80003e1c:	01590633          	add	a2,s2,s5
    80003e20:	faf40593          	addi	a1,s0,-81
    80003e24:	0509b503          	ld	a0,80(s3)
    80003e28:	ffffd097          	auipc	ra,0xffffd
    80003e2c:	d66080e7          	jalr	-666(ra) # 80000b8e <copyin>
    80003e30:	03650263          	beq	a0,s6,80003e54 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003e34:	21c4a783          	lw	a5,540(s1)
    80003e38:	0017871b          	addiw	a4,a5,1
    80003e3c:	20e4ae23          	sw	a4,540(s1)
    80003e40:	1ff7f793          	andi	a5,a5,511
    80003e44:	97a6                	add	a5,a5,s1
    80003e46:	faf44703          	lbu	a4,-81(s0)
    80003e4a:	00e78c23          	sb	a4,24(a5)
      i++;
    80003e4e:	2905                	addiw	s2,s2,1
    80003e50:	b76d                	j	80003dfa <pipewrite+0x80>
  int i = 0;
    80003e52:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003e54:	21848513          	addi	a0,s1,536
    80003e58:	ffffe097          	auipc	ra,0xffffe
    80003e5c:	836080e7          	jalr	-1994(ra) # 8000168e <wakeup>
  release(&pi->lock);
    80003e60:	8526                	mv	a0,s1
    80003e62:	00002097          	auipc	ra,0x2
    80003e66:	262080e7          	jalr	610(ra) # 800060c4 <release>
  return i;
    80003e6a:	b785                	j	80003dca <pipewrite+0x50>

0000000080003e6c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003e6c:	715d                	addi	sp,sp,-80
    80003e6e:	e486                	sd	ra,72(sp)
    80003e70:	e0a2                	sd	s0,64(sp)
    80003e72:	fc26                	sd	s1,56(sp)
    80003e74:	f84a                	sd	s2,48(sp)
    80003e76:	f44e                	sd	s3,40(sp)
    80003e78:	f052                	sd	s4,32(sp)
    80003e7a:	ec56                	sd	s5,24(sp)
    80003e7c:	e85a                	sd	s6,16(sp)
    80003e7e:	0880                	addi	s0,sp,80
    80003e80:	84aa                	mv	s1,a0
    80003e82:	892e                	mv	s2,a1
    80003e84:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003e86:	ffffd097          	auipc	ra,0xffffd
    80003e8a:	fbc080e7          	jalr	-68(ra) # 80000e42 <myproc>
    80003e8e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003e90:	8526                	mv	a0,s1
    80003e92:	00002097          	auipc	ra,0x2
    80003e96:	17e080e7          	jalr	382(ra) # 80006010 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003e9a:	2184a703          	lw	a4,536(s1)
    80003e9e:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003ea2:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ea6:	02f71463          	bne	a4,a5,80003ece <piperead+0x62>
    80003eaa:	2244a783          	lw	a5,548(s1)
    80003eae:	c385                	beqz	a5,80003ece <piperead+0x62>
    if(pr->killed){
    80003eb0:	028a2783          	lw	a5,40(s4)
    80003eb4:	ebc1                	bnez	a5,80003f44 <piperead+0xd8>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003eb6:	85a6                	mv	a1,s1
    80003eb8:	854e                	mv	a0,s3
    80003eba:	ffffd097          	auipc	ra,0xffffd
    80003ebe:	648080e7          	jalr	1608(ra) # 80001502 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ec2:	2184a703          	lw	a4,536(s1)
    80003ec6:	21c4a783          	lw	a5,540(s1)
    80003eca:	fef700e3          	beq	a4,a5,80003eaa <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003ece:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003ed0:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003ed2:	05505363          	blez	s5,80003f18 <piperead+0xac>
    if(pi->nread == pi->nwrite)
    80003ed6:	2184a783          	lw	a5,536(s1)
    80003eda:	21c4a703          	lw	a4,540(s1)
    80003ede:	02f70d63          	beq	a4,a5,80003f18 <piperead+0xac>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003ee2:	0017871b          	addiw	a4,a5,1
    80003ee6:	20e4ac23          	sw	a4,536(s1)
    80003eea:	1ff7f793          	andi	a5,a5,511
    80003eee:	97a6                	add	a5,a5,s1
    80003ef0:	0187c783          	lbu	a5,24(a5)
    80003ef4:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003ef8:	4685                	li	a3,1
    80003efa:	fbf40613          	addi	a2,s0,-65
    80003efe:	85ca                	mv	a1,s2
    80003f00:	050a3503          	ld	a0,80(s4)
    80003f04:	ffffd097          	auipc	ra,0xffffd
    80003f08:	bfe080e7          	jalr	-1026(ra) # 80000b02 <copyout>
    80003f0c:	01650663          	beq	a0,s6,80003f18 <piperead+0xac>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f10:	2985                	addiw	s3,s3,1
    80003f12:	0905                	addi	s2,s2,1
    80003f14:	fd3a91e3          	bne	s5,s3,80003ed6 <piperead+0x6a>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003f18:	21c48513          	addi	a0,s1,540
    80003f1c:	ffffd097          	auipc	ra,0xffffd
    80003f20:	772080e7          	jalr	1906(ra) # 8000168e <wakeup>
  release(&pi->lock);
    80003f24:	8526                	mv	a0,s1
    80003f26:	00002097          	auipc	ra,0x2
    80003f2a:	19e080e7          	jalr	414(ra) # 800060c4 <release>
  return i;
}
    80003f2e:	854e                	mv	a0,s3
    80003f30:	60a6                	ld	ra,72(sp)
    80003f32:	6406                	ld	s0,64(sp)
    80003f34:	74e2                	ld	s1,56(sp)
    80003f36:	7942                	ld	s2,48(sp)
    80003f38:	79a2                	ld	s3,40(sp)
    80003f3a:	7a02                	ld	s4,32(sp)
    80003f3c:	6ae2                	ld	s5,24(sp)
    80003f3e:	6b42                	ld	s6,16(sp)
    80003f40:	6161                	addi	sp,sp,80
    80003f42:	8082                	ret
      release(&pi->lock);
    80003f44:	8526                	mv	a0,s1
    80003f46:	00002097          	auipc	ra,0x2
    80003f4a:	17e080e7          	jalr	382(ra) # 800060c4 <release>
      return -1;
    80003f4e:	59fd                	li	s3,-1
    80003f50:	bff9                	j	80003f2e <piperead+0xc2>

0000000080003f52 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80003f52:	de010113          	addi	sp,sp,-544
    80003f56:	20113c23          	sd	ra,536(sp)
    80003f5a:	20813823          	sd	s0,528(sp)
    80003f5e:	20913423          	sd	s1,520(sp)
    80003f62:	21213023          	sd	s2,512(sp)
    80003f66:	ffce                	sd	s3,504(sp)
    80003f68:	fbd2                	sd	s4,496(sp)
    80003f6a:	f7d6                	sd	s5,488(sp)
    80003f6c:	f3da                	sd	s6,480(sp)
    80003f6e:	efde                	sd	s7,472(sp)
    80003f70:	ebe2                	sd	s8,464(sp)
    80003f72:	e7e6                	sd	s9,456(sp)
    80003f74:	e3ea                	sd	s10,448(sp)
    80003f76:	ff6e                	sd	s11,440(sp)
    80003f78:	1400                	addi	s0,sp,544
    80003f7a:	892a                	mv	s2,a0
    80003f7c:	dea43423          	sd	a0,-536(s0)
    80003f80:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003f84:	ffffd097          	auipc	ra,0xffffd
    80003f88:	ebe080e7          	jalr	-322(ra) # 80000e42 <myproc>
    80003f8c:	84aa                	mv	s1,a0

  begin_op();
    80003f8e:	fffff097          	auipc	ra,0xfffff
    80003f92:	4a6080e7          	jalr	1190(ra) # 80003434 <begin_op>

  if((ip = namei(path)) == 0){
    80003f96:	854a                	mv	a0,s2
    80003f98:	fffff097          	auipc	ra,0xfffff
    80003f9c:	280080e7          	jalr	640(ra) # 80003218 <namei>
    80003fa0:	c93d                	beqz	a0,80004016 <exec+0xc4>
    80003fa2:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003fa4:	fffff097          	auipc	ra,0xfffff
    80003fa8:	abe080e7          	jalr	-1346(ra) # 80002a62 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003fac:	04000713          	li	a4,64
    80003fb0:	4681                	li	a3,0
    80003fb2:	e5040613          	addi	a2,s0,-432
    80003fb6:	4581                	li	a1,0
    80003fb8:	8556                	mv	a0,s5
    80003fba:	fffff097          	auipc	ra,0xfffff
    80003fbe:	d5c080e7          	jalr	-676(ra) # 80002d16 <readi>
    80003fc2:	04000793          	li	a5,64
    80003fc6:	00f51a63          	bne	a0,a5,80003fda <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80003fca:	e5042703          	lw	a4,-432(s0)
    80003fce:	464c47b7          	lui	a5,0x464c4
    80003fd2:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003fd6:	04f70663          	beq	a4,a5,80004022 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003fda:	8556                	mv	a0,s5
    80003fdc:	fffff097          	auipc	ra,0xfffff
    80003fe0:	ce8080e7          	jalr	-792(ra) # 80002cc4 <iunlockput>
    end_op();
    80003fe4:	fffff097          	auipc	ra,0xfffff
    80003fe8:	4d0080e7          	jalr	1232(ra) # 800034b4 <end_op>
  }
  return -1;
    80003fec:	557d                	li	a0,-1
}
    80003fee:	21813083          	ld	ra,536(sp)
    80003ff2:	21013403          	ld	s0,528(sp)
    80003ff6:	20813483          	ld	s1,520(sp)
    80003ffa:	20013903          	ld	s2,512(sp)
    80003ffe:	79fe                	ld	s3,504(sp)
    80004000:	7a5e                	ld	s4,496(sp)
    80004002:	7abe                	ld	s5,488(sp)
    80004004:	7b1e                	ld	s6,480(sp)
    80004006:	6bfe                	ld	s7,472(sp)
    80004008:	6c5e                	ld	s8,464(sp)
    8000400a:	6cbe                	ld	s9,456(sp)
    8000400c:	6d1e                	ld	s10,448(sp)
    8000400e:	7dfa                	ld	s11,440(sp)
    80004010:	22010113          	addi	sp,sp,544
    80004014:	8082                	ret
    end_op();
    80004016:	fffff097          	auipc	ra,0xfffff
    8000401a:	49e080e7          	jalr	1182(ra) # 800034b4 <end_op>
    return -1;
    8000401e:	557d                	li	a0,-1
    80004020:	b7f9                	j	80003fee <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004022:	8526                	mv	a0,s1
    80004024:	ffffd097          	auipc	ra,0xffffd
    80004028:	ee2080e7          	jalr	-286(ra) # 80000f06 <proc_pagetable>
    8000402c:	8b2a                	mv	s6,a0
    8000402e:	d555                	beqz	a0,80003fda <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004030:	e7042783          	lw	a5,-400(s0)
    80004034:	e8845703          	lhu	a4,-376(s0)
    80004038:	c735                	beqz	a4,800040a4 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000403a:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000403c:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    80004040:	6a05                	lui	s4,0x1
    80004042:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004046:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    8000404a:	6d85                	lui	s11,0x1
    8000404c:	7d7d                	lui	s10,0xfffff
    8000404e:	ac1d                	j	80004284 <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004050:	00004517          	auipc	a0,0x4
    80004054:	5f850513          	addi	a0,a0,1528 # 80008648 <syscalls+0x280>
    80004058:	00002097          	auipc	ra,0x2
    8000405c:	a7c080e7          	jalr	-1412(ra) # 80005ad4 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004060:	874a                	mv	a4,s2
    80004062:	009c86bb          	addw	a3,s9,s1
    80004066:	4581                	li	a1,0
    80004068:	8556                	mv	a0,s5
    8000406a:	fffff097          	auipc	ra,0xfffff
    8000406e:	cac080e7          	jalr	-852(ra) # 80002d16 <readi>
    80004072:	2501                	sext.w	a0,a0
    80004074:	1aa91863          	bne	s2,a0,80004224 <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    80004078:	009d84bb          	addw	s1,s11,s1
    8000407c:	013d09bb          	addw	s3,s10,s3
    80004080:	1f74f263          	bgeu	s1,s7,80004264 <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    80004084:	02049593          	slli	a1,s1,0x20
    80004088:	9181                	srli	a1,a1,0x20
    8000408a:	95e2                	add	a1,a1,s8
    8000408c:	855a                	mv	a0,s6
    8000408e:	ffffc097          	auipc	ra,0xffffc
    80004092:	470080e7          	jalr	1136(ra) # 800004fe <walkaddr>
    80004096:	862a                	mv	a2,a0
    if(pa == 0)
    80004098:	dd45                	beqz	a0,80004050 <exec+0xfe>
      n = PGSIZE;
    8000409a:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    8000409c:	fd49f2e3          	bgeu	s3,s4,80004060 <exec+0x10e>
      n = sz - i;
    800040a0:	894e                	mv	s2,s3
    800040a2:	bf7d                	j	80004060 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800040a4:	4481                	li	s1,0
  iunlockput(ip);
    800040a6:	8556                	mv	a0,s5
    800040a8:	fffff097          	auipc	ra,0xfffff
    800040ac:	c1c080e7          	jalr	-996(ra) # 80002cc4 <iunlockput>
  end_op();
    800040b0:	fffff097          	auipc	ra,0xfffff
    800040b4:	404080e7          	jalr	1028(ra) # 800034b4 <end_op>
  p = myproc();
    800040b8:	ffffd097          	auipc	ra,0xffffd
    800040bc:	d8a080e7          	jalr	-630(ra) # 80000e42 <myproc>
    800040c0:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800040c2:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800040c6:	6785                	lui	a5,0x1
    800040c8:	17fd                	addi	a5,a5,-1
    800040ca:	94be                	add	s1,s1,a5
    800040cc:	77fd                	lui	a5,0xfffff
    800040ce:	8fe5                	and	a5,a5,s1
    800040d0:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800040d4:	6609                	lui	a2,0x2
    800040d6:	963e                	add	a2,a2,a5
    800040d8:	85be                	mv	a1,a5
    800040da:	855a                	mv	a0,s6
    800040dc:	ffffc097          	auipc	ra,0xffffc
    800040e0:	7d6080e7          	jalr	2006(ra) # 800008b2 <uvmalloc>
    800040e4:	8c2a                	mv	s8,a0
  ip = 0;
    800040e6:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800040e8:	12050e63          	beqz	a0,80004224 <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    800040ec:	75f9                	lui	a1,0xffffe
    800040ee:	95aa                	add	a1,a1,a0
    800040f0:	855a                	mv	a0,s6
    800040f2:	ffffd097          	auipc	ra,0xffffd
    800040f6:	9de080e7          	jalr	-1570(ra) # 80000ad0 <uvmclear>
  stackbase = sp - PGSIZE;
    800040fa:	7afd                	lui	s5,0xfffff
    800040fc:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    800040fe:	df043783          	ld	a5,-528(s0)
    80004102:	6388                	ld	a0,0(a5)
    80004104:	c925                	beqz	a0,80004174 <exec+0x222>
    80004106:	e9040993          	addi	s3,s0,-368
    8000410a:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000410e:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004110:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004112:	ffffc097          	auipc	ra,0xffffc
    80004116:	1e2080e7          	jalr	482(ra) # 800002f4 <strlen>
    8000411a:	0015079b          	addiw	a5,a0,1
    8000411e:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004122:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004126:	13596363          	bltu	s2,s5,8000424c <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000412a:	df043d83          	ld	s11,-528(s0)
    8000412e:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004132:	8552                	mv	a0,s4
    80004134:	ffffc097          	auipc	ra,0xffffc
    80004138:	1c0080e7          	jalr	448(ra) # 800002f4 <strlen>
    8000413c:	0015069b          	addiw	a3,a0,1
    80004140:	8652                	mv	a2,s4
    80004142:	85ca                	mv	a1,s2
    80004144:	855a                	mv	a0,s6
    80004146:	ffffd097          	auipc	ra,0xffffd
    8000414a:	9bc080e7          	jalr	-1604(ra) # 80000b02 <copyout>
    8000414e:	10054363          	bltz	a0,80004254 <exec+0x302>
    ustack[argc] = sp;
    80004152:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004156:	0485                	addi	s1,s1,1
    80004158:	008d8793          	addi	a5,s11,8
    8000415c:	def43823          	sd	a5,-528(s0)
    80004160:	008db503          	ld	a0,8(s11)
    80004164:	c911                	beqz	a0,80004178 <exec+0x226>
    if(argc >= MAXARG)
    80004166:	09a1                	addi	s3,s3,8
    80004168:	fb3c95e3          	bne	s9,s3,80004112 <exec+0x1c0>
  sz = sz1;
    8000416c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004170:	4a81                	li	s5,0
    80004172:	a84d                	j	80004224 <exec+0x2d2>
  sp = sz;
    80004174:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004176:	4481                	li	s1,0
  ustack[argc] = 0;
    80004178:	00349793          	slli	a5,s1,0x3
    8000417c:	f9040713          	addi	a4,s0,-112
    80004180:	97ba                	add	a5,a5,a4
    80004182:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffd8cc0>
  sp -= (argc+1) * sizeof(uint64);
    80004186:	00148693          	addi	a3,s1,1
    8000418a:	068e                	slli	a3,a3,0x3
    8000418c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004190:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004194:	01597663          	bgeu	s2,s5,800041a0 <exec+0x24e>
  sz = sz1;
    80004198:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000419c:	4a81                	li	s5,0
    8000419e:	a059                	j	80004224 <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800041a0:	e9040613          	addi	a2,s0,-368
    800041a4:	85ca                	mv	a1,s2
    800041a6:	855a                	mv	a0,s6
    800041a8:	ffffd097          	auipc	ra,0xffffd
    800041ac:	95a080e7          	jalr	-1702(ra) # 80000b02 <copyout>
    800041b0:	0a054663          	bltz	a0,8000425c <exec+0x30a>
  p->trapframe->a1 = sp;
    800041b4:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    800041b8:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800041bc:	de843783          	ld	a5,-536(s0)
    800041c0:	0007c703          	lbu	a4,0(a5)
    800041c4:	cf11                	beqz	a4,800041e0 <exec+0x28e>
    800041c6:	0785                	addi	a5,a5,1
    if(*s == '/')
    800041c8:	02f00693          	li	a3,47
    800041cc:	a039                	j	800041da <exec+0x288>
      last = s+1;
    800041ce:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    800041d2:	0785                	addi	a5,a5,1
    800041d4:	fff7c703          	lbu	a4,-1(a5)
    800041d8:	c701                	beqz	a4,800041e0 <exec+0x28e>
    if(*s == '/')
    800041da:	fed71ce3          	bne	a4,a3,800041d2 <exec+0x280>
    800041de:	bfc5                	j	800041ce <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    800041e0:	4641                	li	a2,16
    800041e2:	de843583          	ld	a1,-536(s0)
    800041e6:	158b8513          	addi	a0,s7,344
    800041ea:	ffffc097          	auipc	ra,0xffffc
    800041ee:	0d8080e7          	jalr	216(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    800041f2:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    800041f6:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    800041fa:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800041fe:	058bb783          	ld	a5,88(s7)
    80004202:	e6843703          	ld	a4,-408(s0)
    80004206:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004208:	058bb783          	ld	a5,88(s7)
    8000420c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004210:	85ea                	mv	a1,s10
    80004212:	ffffd097          	auipc	ra,0xffffd
    80004216:	d90080e7          	jalr	-624(ra) # 80000fa2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000421a:	0004851b          	sext.w	a0,s1
    8000421e:	bbc1                	j	80003fee <exec+0x9c>
    80004220:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004224:	df843583          	ld	a1,-520(s0)
    80004228:	855a                	mv	a0,s6
    8000422a:	ffffd097          	auipc	ra,0xffffd
    8000422e:	d78080e7          	jalr	-648(ra) # 80000fa2 <proc_freepagetable>
  if(ip){
    80004232:	da0a94e3          	bnez	s5,80003fda <exec+0x88>
  return -1;
    80004236:	557d                	li	a0,-1
    80004238:	bb5d                	j	80003fee <exec+0x9c>
    8000423a:	de943c23          	sd	s1,-520(s0)
    8000423e:	b7dd                	j	80004224 <exec+0x2d2>
    80004240:	de943c23          	sd	s1,-520(s0)
    80004244:	b7c5                	j	80004224 <exec+0x2d2>
    80004246:	de943c23          	sd	s1,-520(s0)
    8000424a:	bfe9                	j	80004224 <exec+0x2d2>
  sz = sz1;
    8000424c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004250:	4a81                	li	s5,0
    80004252:	bfc9                	j	80004224 <exec+0x2d2>
  sz = sz1;
    80004254:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004258:	4a81                	li	s5,0
    8000425a:	b7e9                	j	80004224 <exec+0x2d2>
  sz = sz1;
    8000425c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004260:	4a81                	li	s5,0
    80004262:	b7c9                	j	80004224 <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004264:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004268:	e0843783          	ld	a5,-504(s0)
    8000426c:	0017869b          	addiw	a3,a5,1
    80004270:	e0d43423          	sd	a3,-504(s0)
    80004274:	e0043783          	ld	a5,-512(s0)
    80004278:	0387879b          	addiw	a5,a5,56
    8000427c:	e8845703          	lhu	a4,-376(s0)
    80004280:	e2e6d3e3          	bge	a3,a4,800040a6 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004284:	2781                	sext.w	a5,a5
    80004286:	e0f43023          	sd	a5,-512(s0)
    8000428a:	03800713          	li	a4,56
    8000428e:	86be                	mv	a3,a5
    80004290:	e1840613          	addi	a2,s0,-488
    80004294:	4581                	li	a1,0
    80004296:	8556                	mv	a0,s5
    80004298:	fffff097          	auipc	ra,0xfffff
    8000429c:	a7e080e7          	jalr	-1410(ra) # 80002d16 <readi>
    800042a0:	03800793          	li	a5,56
    800042a4:	f6f51ee3          	bne	a0,a5,80004220 <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    800042a8:	e1842783          	lw	a5,-488(s0)
    800042ac:	4705                	li	a4,1
    800042ae:	fae79de3          	bne	a5,a4,80004268 <exec+0x316>
    if(ph.memsz < ph.filesz)
    800042b2:	e4043603          	ld	a2,-448(s0)
    800042b6:	e3843783          	ld	a5,-456(s0)
    800042ba:	f8f660e3          	bltu	a2,a5,8000423a <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800042be:	e2843783          	ld	a5,-472(s0)
    800042c2:	963e                	add	a2,a2,a5
    800042c4:	f6f66ee3          	bltu	a2,a5,80004240 <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800042c8:	85a6                	mv	a1,s1
    800042ca:	855a                	mv	a0,s6
    800042cc:	ffffc097          	auipc	ra,0xffffc
    800042d0:	5e6080e7          	jalr	1510(ra) # 800008b2 <uvmalloc>
    800042d4:	dea43c23          	sd	a0,-520(s0)
    800042d8:	d53d                	beqz	a0,80004246 <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    800042da:	e2843c03          	ld	s8,-472(s0)
    800042de:	de043783          	ld	a5,-544(s0)
    800042e2:	00fc77b3          	and	a5,s8,a5
    800042e6:	ff9d                	bnez	a5,80004224 <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800042e8:	e2042c83          	lw	s9,-480(s0)
    800042ec:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800042f0:	f60b8ae3          	beqz	s7,80004264 <exec+0x312>
    800042f4:	89de                	mv	s3,s7
    800042f6:	4481                	li	s1,0
    800042f8:	b371                	j	80004084 <exec+0x132>

00000000800042fa <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800042fa:	7179                	addi	sp,sp,-48
    800042fc:	f406                	sd	ra,40(sp)
    800042fe:	f022                	sd	s0,32(sp)
    80004300:	ec26                	sd	s1,24(sp)
    80004302:	e84a                	sd	s2,16(sp)
    80004304:	1800                	addi	s0,sp,48
    80004306:	892e                	mv	s2,a1
    80004308:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000430a:	fdc40593          	addi	a1,s0,-36
    8000430e:	ffffe097          	auipc	ra,0xffffe
    80004312:	be4080e7          	jalr	-1052(ra) # 80001ef2 <argint>
    80004316:	04054063          	bltz	a0,80004356 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000431a:	fdc42703          	lw	a4,-36(s0)
    8000431e:	47bd                	li	a5,15
    80004320:	02e7ed63          	bltu	a5,a4,8000435a <argfd+0x60>
    80004324:	ffffd097          	auipc	ra,0xffffd
    80004328:	b1e080e7          	jalr	-1250(ra) # 80000e42 <myproc>
    8000432c:	fdc42703          	lw	a4,-36(s0)
    80004330:	01a70793          	addi	a5,a4,26
    80004334:	078e                	slli	a5,a5,0x3
    80004336:	953e                	add	a0,a0,a5
    80004338:	611c                	ld	a5,0(a0)
    8000433a:	c395                	beqz	a5,8000435e <argfd+0x64>
    return -1;
  if(pfd)
    8000433c:	00090463          	beqz	s2,80004344 <argfd+0x4a>
    *pfd = fd;
    80004340:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004344:	4501                	li	a0,0
  if(pf)
    80004346:	c091                	beqz	s1,8000434a <argfd+0x50>
    *pf = f;
    80004348:	e09c                	sd	a5,0(s1)
}
    8000434a:	70a2                	ld	ra,40(sp)
    8000434c:	7402                	ld	s0,32(sp)
    8000434e:	64e2                	ld	s1,24(sp)
    80004350:	6942                	ld	s2,16(sp)
    80004352:	6145                	addi	sp,sp,48
    80004354:	8082                	ret
    return -1;
    80004356:	557d                	li	a0,-1
    80004358:	bfcd                	j	8000434a <argfd+0x50>
    return -1;
    8000435a:	557d                	li	a0,-1
    8000435c:	b7fd                	j	8000434a <argfd+0x50>
    8000435e:	557d                	li	a0,-1
    80004360:	b7ed                	j	8000434a <argfd+0x50>

0000000080004362 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004362:	1101                	addi	sp,sp,-32
    80004364:	ec06                	sd	ra,24(sp)
    80004366:	e822                	sd	s0,16(sp)
    80004368:	e426                	sd	s1,8(sp)
    8000436a:	1000                	addi	s0,sp,32
    8000436c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000436e:	ffffd097          	auipc	ra,0xffffd
    80004372:	ad4080e7          	jalr	-1324(ra) # 80000e42 <myproc>
    80004376:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004378:	0d050793          	addi	a5,a0,208
    8000437c:	4501                	li	a0,0
    8000437e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004380:	6398                	ld	a4,0(a5)
    80004382:	cb19                	beqz	a4,80004398 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004384:	2505                	addiw	a0,a0,1
    80004386:	07a1                	addi	a5,a5,8
    80004388:	fed51ce3          	bne	a0,a3,80004380 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000438c:	557d                	li	a0,-1
}
    8000438e:	60e2                	ld	ra,24(sp)
    80004390:	6442                	ld	s0,16(sp)
    80004392:	64a2                	ld	s1,8(sp)
    80004394:	6105                	addi	sp,sp,32
    80004396:	8082                	ret
      p->ofile[fd] = f;
    80004398:	01a50793          	addi	a5,a0,26
    8000439c:	078e                	slli	a5,a5,0x3
    8000439e:	963e                	add	a2,a2,a5
    800043a0:	e204                	sd	s1,0(a2)
      return fd;
    800043a2:	b7f5                	j	8000438e <fdalloc+0x2c>

00000000800043a4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800043a4:	715d                	addi	sp,sp,-80
    800043a6:	e486                	sd	ra,72(sp)
    800043a8:	e0a2                	sd	s0,64(sp)
    800043aa:	fc26                	sd	s1,56(sp)
    800043ac:	f84a                	sd	s2,48(sp)
    800043ae:	f44e                	sd	s3,40(sp)
    800043b0:	f052                	sd	s4,32(sp)
    800043b2:	ec56                	sd	s5,24(sp)
    800043b4:	0880                	addi	s0,sp,80
    800043b6:	89ae                	mv	s3,a1
    800043b8:	8ab2                	mv	s5,a2
    800043ba:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800043bc:	fb040593          	addi	a1,s0,-80
    800043c0:	fffff097          	auipc	ra,0xfffff
    800043c4:	e76080e7          	jalr	-394(ra) # 80003236 <nameiparent>
    800043c8:	892a                	mv	s2,a0
    800043ca:	12050e63          	beqz	a0,80004506 <create+0x162>
    return 0;

  ilock(dp);
    800043ce:	ffffe097          	auipc	ra,0xffffe
    800043d2:	694080e7          	jalr	1684(ra) # 80002a62 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800043d6:	4601                	li	a2,0
    800043d8:	fb040593          	addi	a1,s0,-80
    800043dc:	854a                	mv	a0,s2
    800043de:	fffff097          	auipc	ra,0xfffff
    800043e2:	b68080e7          	jalr	-1176(ra) # 80002f46 <dirlookup>
    800043e6:	84aa                	mv	s1,a0
    800043e8:	c921                	beqz	a0,80004438 <create+0x94>
    iunlockput(dp);
    800043ea:	854a                	mv	a0,s2
    800043ec:	fffff097          	auipc	ra,0xfffff
    800043f0:	8d8080e7          	jalr	-1832(ra) # 80002cc4 <iunlockput>
    ilock(ip);
    800043f4:	8526                	mv	a0,s1
    800043f6:	ffffe097          	auipc	ra,0xffffe
    800043fa:	66c080e7          	jalr	1644(ra) # 80002a62 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800043fe:	2981                	sext.w	s3,s3
    80004400:	4789                	li	a5,2
    80004402:	02f99463          	bne	s3,a5,8000442a <create+0x86>
    80004406:	0444d783          	lhu	a5,68(s1)
    8000440a:	37f9                	addiw	a5,a5,-2
    8000440c:	17c2                	slli	a5,a5,0x30
    8000440e:	93c1                	srli	a5,a5,0x30
    80004410:	4705                	li	a4,1
    80004412:	00f76c63          	bltu	a4,a5,8000442a <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004416:	8526                	mv	a0,s1
    80004418:	60a6                	ld	ra,72(sp)
    8000441a:	6406                	ld	s0,64(sp)
    8000441c:	74e2                	ld	s1,56(sp)
    8000441e:	7942                	ld	s2,48(sp)
    80004420:	79a2                	ld	s3,40(sp)
    80004422:	7a02                	ld	s4,32(sp)
    80004424:	6ae2                	ld	s5,24(sp)
    80004426:	6161                	addi	sp,sp,80
    80004428:	8082                	ret
    iunlockput(ip);
    8000442a:	8526                	mv	a0,s1
    8000442c:	fffff097          	auipc	ra,0xfffff
    80004430:	898080e7          	jalr	-1896(ra) # 80002cc4 <iunlockput>
    return 0;
    80004434:	4481                	li	s1,0
    80004436:	b7c5                	j	80004416 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004438:	85ce                	mv	a1,s3
    8000443a:	00092503          	lw	a0,0(s2)
    8000443e:	ffffe097          	auipc	ra,0xffffe
    80004442:	48c080e7          	jalr	1164(ra) # 800028ca <ialloc>
    80004446:	84aa                	mv	s1,a0
    80004448:	c521                	beqz	a0,80004490 <create+0xec>
  ilock(ip);
    8000444a:	ffffe097          	auipc	ra,0xffffe
    8000444e:	618080e7          	jalr	1560(ra) # 80002a62 <ilock>
  ip->major = major;
    80004452:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004456:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    8000445a:	4a05                	li	s4,1
    8000445c:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80004460:	8526                	mv	a0,s1
    80004462:	ffffe097          	auipc	ra,0xffffe
    80004466:	536080e7          	jalr	1334(ra) # 80002998 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000446a:	2981                	sext.w	s3,s3
    8000446c:	03498a63          	beq	s3,s4,800044a0 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80004470:	40d0                	lw	a2,4(s1)
    80004472:	fb040593          	addi	a1,s0,-80
    80004476:	854a                	mv	a0,s2
    80004478:	fffff097          	auipc	ra,0xfffff
    8000447c:	cde080e7          	jalr	-802(ra) # 80003156 <dirlink>
    80004480:	06054b63          	bltz	a0,800044f6 <create+0x152>
  iunlockput(dp);
    80004484:	854a                	mv	a0,s2
    80004486:	fffff097          	auipc	ra,0xfffff
    8000448a:	83e080e7          	jalr	-1986(ra) # 80002cc4 <iunlockput>
  return ip;
    8000448e:	b761                	j	80004416 <create+0x72>
    panic("create: ialloc");
    80004490:	00004517          	auipc	a0,0x4
    80004494:	1d850513          	addi	a0,a0,472 # 80008668 <syscalls+0x2a0>
    80004498:	00001097          	auipc	ra,0x1
    8000449c:	63c080e7          	jalr	1596(ra) # 80005ad4 <panic>
    dp->nlink++;  // for ".."
    800044a0:	04a95783          	lhu	a5,74(s2)
    800044a4:	2785                	addiw	a5,a5,1
    800044a6:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800044aa:	854a                	mv	a0,s2
    800044ac:	ffffe097          	auipc	ra,0xffffe
    800044b0:	4ec080e7          	jalr	1260(ra) # 80002998 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800044b4:	40d0                	lw	a2,4(s1)
    800044b6:	00004597          	auipc	a1,0x4
    800044ba:	1c258593          	addi	a1,a1,450 # 80008678 <syscalls+0x2b0>
    800044be:	8526                	mv	a0,s1
    800044c0:	fffff097          	auipc	ra,0xfffff
    800044c4:	c96080e7          	jalr	-874(ra) # 80003156 <dirlink>
    800044c8:	00054f63          	bltz	a0,800044e6 <create+0x142>
    800044cc:	00492603          	lw	a2,4(s2)
    800044d0:	00004597          	auipc	a1,0x4
    800044d4:	1b058593          	addi	a1,a1,432 # 80008680 <syscalls+0x2b8>
    800044d8:	8526                	mv	a0,s1
    800044da:	fffff097          	auipc	ra,0xfffff
    800044de:	c7c080e7          	jalr	-900(ra) # 80003156 <dirlink>
    800044e2:	f80557e3          	bgez	a0,80004470 <create+0xcc>
      panic("create dots");
    800044e6:	00004517          	auipc	a0,0x4
    800044ea:	1a250513          	addi	a0,a0,418 # 80008688 <syscalls+0x2c0>
    800044ee:	00001097          	auipc	ra,0x1
    800044f2:	5e6080e7          	jalr	1510(ra) # 80005ad4 <panic>
    panic("create: dirlink");
    800044f6:	00004517          	auipc	a0,0x4
    800044fa:	1a250513          	addi	a0,a0,418 # 80008698 <syscalls+0x2d0>
    800044fe:	00001097          	auipc	ra,0x1
    80004502:	5d6080e7          	jalr	1494(ra) # 80005ad4 <panic>
    return 0;
    80004506:	84aa                	mv	s1,a0
    80004508:	b739                	j	80004416 <create+0x72>

000000008000450a <sys_dup>:
{
    8000450a:	7179                	addi	sp,sp,-48
    8000450c:	f406                	sd	ra,40(sp)
    8000450e:	f022                	sd	s0,32(sp)
    80004510:	ec26                	sd	s1,24(sp)
    80004512:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004514:	fd840613          	addi	a2,s0,-40
    80004518:	4581                	li	a1,0
    8000451a:	4501                	li	a0,0
    8000451c:	00000097          	auipc	ra,0x0
    80004520:	dde080e7          	jalr	-546(ra) # 800042fa <argfd>
    return -1;
    80004524:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004526:	02054363          	bltz	a0,8000454c <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000452a:	fd843503          	ld	a0,-40(s0)
    8000452e:	00000097          	auipc	ra,0x0
    80004532:	e34080e7          	jalr	-460(ra) # 80004362 <fdalloc>
    80004536:	84aa                	mv	s1,a0
    return -1;
    80004538:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000453a:	00054963          	bltz	a0,8000454c <sys_dup+0x42>
  filedup(f);
    8000453e:	fd843503          	ld	a0,-40(s0)
    80004542:	fffff097          	auipc	ra,0xfffff
    80004546:	36c080e7          	jalr	876(ra) # 800038ae <filedup>
  return fd;
    8000454a:	87a6                	mv	a5,s1
}
    8000454c:	853e                	mv	a0,a5
    8000454e:	70a2                	ld	ra,40(sp)
    80004550:	7402                	ld	s0,32(sp)
    80004552:	64e2                	ld	s1,24(sp)
    80004554:	6145                	addi	sp,sp,48
    80004556:	8082                	ret

0000000080004558 <sys_read>:
{
    80004558:	7179                	addi	sp,sp,-48
    8000455a:	f406                	sd	ra,40(sp)
    8000455c:	f022                	sd	s0,32(sp)
    8000455e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004560:	fe840613          	addi	a2,s0,-24
    80004564:	4581                	li	a1,0
    80004566:	4501                	li	a0,0
    80004568:	00000097          	auipc	ra,0x0
    8000456c:	d92080e7          	jalr	-622(ra) # 800042fa <argfd>
    return -1;
    80004570:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004572:	04054163          	bltz	a0,800045b4 <sys_read+0x5c>
    80004576:	fe440593          	addi	a1,s0,-28
    8000457a:	4509                	li	a0,2
    8000457c:	ffffe097          	auipc	ra,0xffffe
    80004580:	976080e7          	jalr	-1674(ra) # 80001ef2 <argint>
    return -1;
    80004584:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004586:	02054763          	bltz	a0,800045b4 <sys_read+0x5c>
    8000458a:	fd840593          	addi	a1,s0,-40
    8000458e:	4505                	li	a0,1
    80004590:	ffffe097          	auipc	ra,0xffffe
    80004594:	984080e7          	jalr	-1660(ra) # 80001f14 <argaddr>
    return -1;
    80004598:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000459a:	00054d63          	bltz	a0,800045b4 <sys_read+0x5c>
  return fileread(f, p, n);
    8000459e:	fe442603          	lw	a2,-28(s0)
    800045a2:	fd843583          	ld	a1,-40(s0)
    800045a6:	fe843503          	ld	a0,-24(s0)
    800045aa:	fffff097          	auipc	ra,0xfffff
    800045ae:	490080e7          	jalr	1168(ra) # 80003a3a <fileread>
    800045b2:	87aa                	mv	a5,a0
}
    800045b4:	853e                	mv	a0,a5
    800045b6:	70a2                	ld	ra,40(sp)
    800045b8:	7402                	ld	s0,32(sp)
    800045ba:	6145                	addi	sp,sp,48
    800045bc:	8082                	ret

00000000800045be <sys_write>:
{
    800045be:	7179                	addi	sp,sp,-48
    800045c0:	f406                	sd	ra,40(sp)
    800045c2:	f022                	sd	s0,32(sp)
    800045c4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800045c6:	fe840613          	addi	a2,s0,-24
    800045ca:	4581                	li	a1,0
    800045cc:	4501                	li	a0,0
    800045ce:	00000097          	auipc	ra,0x0
    800045d2:	d2c080e7          	jalr	-724(ra) # 800042fa <argfd>
    return -1;
    800045d6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800045d8:	04054163          	bltz	a0,8000461a <sys_write+0x5c>
    800045dc:	fe440593          	addi	a1,s0,-28
    800045e0:	4509                	li	a0,2
    800045e2:	ffffe097          	auipc	ra,0xffffe
    800045e6:	910080e7          	jalr	-1776(ra) # 80001ef2 <argint>
    return -1;
    800045ea:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800045ec:	02054763          	bltz	a0,8000461a <sys_write+0x5c>
    800045f0:	fd840593          	addi	a1,s0,-40
    800045f4:	4505                	li	a0,1
    800045f6:	ffffe097          	auipc	ra,0xffffe
    800045fa:	91e080e7          	jalr	-1762(ra) # 80001f14 <argaddr>
    return -1;
    800045fe:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004600:	00054d63          	bltz	a0,8000461a <sys_write+0x5c>
  return filewrite(f, p, n);
    80004604:	fe442603          	lw	a2,-28(s0)
    80004608:	fd843583          	ld	a1,-40(s0)
    8000460c:	fe843503          	ld	a0,-24(s0)
    80004610:	fffff097          	auipc	ra,0xfffff
    80004614:	4ec080e7          	jalr	1260(ra) # 80003afc <filewrite>
    80004618:	87aa                	mv	a5,a0
}
    8000461a:	853e                	mv	a0,a5
    8000461c:	70a2                	ld	ra,40(sp)
    8000461e:	7402                	ld	s0,32(sp)
    80004620:	6145                	addi	sp,sp,48
    80004622:	8082                	ret

0000000080004624 <sys_close>:
{
    80004624:	1101                	addi	sp,sp,-32
    80004626:	ec06                	sd	ra,24(sp)
    80004628:	e822                	sd	s0,16(sp)
    8000462a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000462c:	fe040613          	addi	a2,s0,-32
    80004630:	fec40593          	addi	a1,s0,-20
    80004634:	4501                	li	a0,0
    80004636:	00000097          	auipc	ra,0x0
    8000463a:	cc4080e7          	jalr	-828(ra) # 800042fa <argfd>
    return -1;
    8000463e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004640:	02054463          	bltz	a0,80004668 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004644:	ffffc097          	auipc	ra,0xffffc
    80004648:	7fe080e7          	jalr	2046(ra) # 80000e42 <myproc>
    8000464c:	fec42783          	lw	a5,-20(s0)
    80004650:	07e9                	addi	a5,a5,26
    80004652:	078e                	slli	a5,a5,0x3
    80004654:	97aa                	add	a5,a5,a0
    80004656:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    8000465a:	fe043503          	ld	a0,-32(s0)
    8000465e:	fffff097          	auipc	ra,0xfffff
    80004662:	2a2080e7          	jalr	674(ra) # 80003900 <fileclose>
  return 0;
    80004666:	4781                	li	a5,0
}
    80004668:	853e                	mv	a0,a5
    8000466a:	60e2                	ld	ra,24(sp)
    8000466c:	6442                	ld	s0,16(sp)
    8000466e:	6105                	addi	sp,sp,32
    80004670:	8082                	ret

0000000080004672 <sys_fstat>:
{
    80004672:	1101                	addi	sp,sp,-32
    80004674:	ec06                	sd	ra,24(sp)
    80004676:	e822                	sd	s0,16(sp)
    80004678:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000467a:	fe840613          	addi	a2,s0,-24
    8000467e:	4581                	li	a1,0
    80004680:	4501                	li	a0,0
    80004682:	00000097          	auipc	ra,0x0
    80004686:	c78080e7          	jalr	-904(ra) # 800042fa <argfd>
    return -1;
    8000468a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000468c:	02054563          	bltz	a0,800046b6 <sys_fstat+0x44>
    80004690:	fe040593          	addi	a1,s0,-32
    80004694:	4505                	li	a0,1
    80004696:	ffffe097          	auipc	ra,0xffffe
    8000469a:	87e080e7          	jalr	-1922(ra) # 80001f14 <argaddr>
    return -1;
    8000469e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800046a0:	00054b63          	bltz	a0,800046b6 <sys_fstat+0x44>
  return filestat(f, st);
    800046a4:	fe043583          	ld	a1,-32(s0)
    800046a8:	fe843503          	ld	a0,-24(s0)
    800046ac:	fffff097          	auipc	ra,0xfffff
    800046b0:	31c080e7          	jalr	796(ra) # 800039c8 <filestat>
    800046b4:	87aa                	mv	a5,a0
}
    800046b6:	853e                	mv	a0,a5
    800046b8:	60e2                	ld	ra,24(sp)
    800046ba:	6442                	ld	s0,16(sp)
    800046bc:	6105                	addi	sp,sp,32
    800046be:	8082                	ret

00000000800046c0 <sys_link>:
{
    800046c0:	7169                	addi	sp,sp,-304
    800046c2:	f606                	sd	ra,296(sp)
    800046c4:	f222                	sd	s0,288(sp)
    800046c6:	ee26                	sd	s1,280(sp)
    800046c8:	ea4a                	sd	s2,272(sp)
    800046ca:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800046cc:	08000613          	li	a2,128
    800046d0:	ed040593          	addi	a1,s0,-304
    800046d4:	4501                	li	a0,0
    800046d6:	ffffe097          	auipc	ra,0xffffe
    800046da:	860080e7          	jalr	-1952(ra) # 80001f36 <argstr>
    return -1;
    800046de:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800046e0:	10054e63          	bltz	a0,800047fc <sys_link+0x13c>
    800046e4:	08000613          	li	a2,128
    800046e8:	f5040593          	addi	a1,s0,-176
    800046ec:	4505                	li	a0,1
    800046ee:	ffffe097          	auipc	ra,0xffffe
    800046f2:	848080e7          	jalr	-1976(ra) # 80001f36 <argstr>
    return -1;
    800046f6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800046f8:	10054263          	bltz	a0,800047fc <sys_link+0x13c>
  begin_op();
    800046fc:	fffff097          	auipc	ra,0xfffff
    80004700:	d38080e7          	jalr	-712(ra) # 80003434 <begin_op>
  if((ip = namei(old)) == 0){
    80004704:	ed040513          	addi	a0,s0,-304
    80004708:	fffff097          	auipc	ra,0xfffff
    8000470c:	b10080e7          	jalr	-1264(ra) # 80003218 <namei>
    80004710:	84aa                	mv	s1,a0
    80004712:	c551                	beqz	a0,8000479e <sys_link+0xde>
  ilock(ip);
    80004714:	ffffe097          	auipc	ra,0xffffe
    80004718:	34e080e7          	jalr	846(ra) # 80002a62 <ilock>
  if(ip->type == T_DIR){
    8000471c:	04449703          	lh	a4,68(s1)
    80004720:	4785                	li	a5,1
    80004722:	08f70463          	beq	a4,a5,800047aa <sys_link+0xea>
  ip->nlink++;
    80004726:	04a4d783          	lhu	a5,74(s1)
    8000472a:	2785                	addiw	a5,a5,1
    8000472c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004730:	8526                	mv	a0,s1
    80004732:	ffffe097          	auipc	ra,0xffffe
    80004736:	266080e7          	jalr	614(ra) # 80002998 <iupdate>
  iunlock(ip);
    8000473a:	8526                	mv	a0,s1
    8000473c:	ffffe097          	auipc	ra,0xffffe
    80004740:	3e8080e7          	jalr	1000(ra) # 80002b24 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004744:	fd040593          	addi	a1,s0,-48
    80004748:	f5040513          	addi	a0,s0,-176
    8000474c:	fffff097          	auipc	ra,0xfffff
    80004750:	aea080e7          	jalr	-1302(ra) # 80003236 <nameiparent>
    80004754:	892a                	mv	s2,a0
    80004756:	c935                	beqz	a0,800047ca <sys_link+0x10a>
  ilock(dp);
    80004758:	ffffe097          	auipc	ra,0xffffe
    8000475c:	30a080e7          	jalr	778(ra) # 80002a62 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004760:	00092703          	lw	a4,0(s2)
    80004764:	409c                	lw	a5,0(s1)
    80004766:	04f71d63          	bne	a4,a5,800047c0 <sys_link+0x100>
    8000476a:	40d0                	lw	a2,4(s1)
    8000476c:	fd040593          	addi	a1,s0,-48
    80004770:	854a                	mv	a0,s2
    80004772:	fffff097          	auipc	ra,0xfffff
    80004776:	9e4080e7          	jalr	-1564(ra) # 80003156 <dirlink>
    8000477a:	04054363          	bltz	a0,800047c0 <sys_link+0x100>
  iunlockput(dp);
    8000477e:	854a                	mv	a0,s2
    80004780:	ffffe097          	auipc	ra,0xffffe
    80004784:	544080e7          	jalr	1348(ra) # 80002cc4 <iunlockput>
  iput(ip);
    80004788:	8526                	mv	a0,s1
    8000478a:	ffffe097          	auipc	ra,0xffffe
    8000478e:	492080e7          	jalr	1170(ra) # 80002c1c <iput>
  end_op();
    80004792:	fffff097          	auipc	ra,0xfffff
    80004796:	d22080e7          	jalr	-734(ra) # 800034b4 <end_op>
  return 0;
    8000479a:	4781                	li	a5,0
    8000479c:	a085                	j	800047fc <sys_link+0x13c>
    end_op();
    8000479e:	fffff097          	auipc	ra,0xfffff
    800047a2:	d16080e7          	jalr	-746(ra) # 800034b4 <end_op>
    return -1;
    800047a6:	57fd                	li	a5,-1
    800047a8:	a891                	j	800047fc <sys_link+0x13c>
    iunlockput(ip);
    800047aa:	8526                	mv	a0,s1
    800047ac:	ffffe097          	auipc	ra,0xffffe
    800047b0:	518080e7          	jalr	1304(ra) # 80002cc4 <iunlockput>
    end_op();
    800047b4:	fffff097          	auipc	ra,0xfffff
    800047b8:	d00080e7          	jalr	-768(ra) # 800034b4 <end_op>
    return -1;
    800047bc:	57fd                	li	a5,-1
    800047be:	a83d                	j	800047fc <sys_link+0x13c>
    iunlockput(dp);
    800047c0:	854a                	mv	a0,s2
    800047c2:	ffffe097          	auipc	ra,0xffffe
    800047c6:	502080e7          	jalr	1282(ra) # 80002cc4 <iunlockput>
  ilock(ip);
    800047ca:	8526                	mv	a0,s1
    800047cc:	ffffe097          	auipc	ra,0xffffe
    800047d0:	296080e7          	jalr	662(ra) # 80002a62 <ilock>
  ip->nlink--;
    800047d4:	04a4d783          	lhu	a5,74(s1)
    800047d8:	37fd                	addiw	a5,a5,-1
    800047da:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800047de:	8526                	mv	a0,s1
    800047e0:	ffffe097          	auipc	ra,0xffffe
    800047e4:	1b8080e7          	jalr	440(ra) # 80002998 <iupdate>
  iunlockput(ip);
    800047e8:	8526                	mv	a0,s1
    800047ea:	ffffe097          	auipc	ra,0xffffe
    800047ee:	4da080e7          	jalr	1242(ra) # 80002cc4 <iunlockput>
  end_op();
    800047f2:	fffff097          	auipc	ra,0xfffff
    800047f6:	cc2080e7          	jalr	-830(ra) # 800034b4 <end_op>
  return -1;
    800047fa:	57fd                	li	a5,-1
}
    800047fc:	853e                	mv	a0,a5
    800047fe:	70b2                	ld	ra,296(sp)
    80004800:	7412                	ld	s0,288(sp)
    80004802:	64f2                	ld	s1,280(sp)
    80004804:	6952                	ld	s2,272(sp)
    80004806:	6155                	addi	sp,sp,304
    80004808:	8082                	ret

000000008000480a <sys_unlink>:
{
    8000480a:	7151                	addi	sp,sp,-240
    8000480c:	f586                	sd	ra,232(sp)
    8000480e:	f1a2                	sd	s0,224(sp)
    80004810:	eda6                	sd	s1,216(sp)
    80004812:	e9ca                	sd	s2,208(sp)
    80004814:	e5ce                	sd	s3,200(sp)
    80004816:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004818:	08000613          	li	a2,128
    8000481c:	f3040593          	addi	a1,s0,-208
    80004820:	4501                	li	a0,0
    80004822:	ffffd097          	auipc	ra,0xffffd
    80004826:	714080e7          	jalr	1812(ra) # 80001f36 <argstr>
    8000482a:	18054163          	bltz	a0,800049ac <sys_unlink+0x1a2>
  begin_op();
    8000482e:	fffff097          	auipc	ra,0xfffff
    80004832:	c06080e7          	jalr	-1018(ra) # 80003434 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004836:	fb040593          	addi	a1,s0,-80
    8000483a:	f3040513          	addi	a0,s0,-208
    8000483e:	fffff097          	auipc	ra,0xfffff
    80004842:	9f8080e7          	jalr	-1544(ra) # 80003236 <nameiparent>
    80004846:	84aa                	mv	s1,a0
    80004848:	c979                	beqz	a0,8000491e <sys_unlink+0x114>
  ilock(dp);
    8000484a:	ffffe097          	auipc	ra,0xffffe
    8000484e:	218080e7          	jalr	536(ra) # 80002a62 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004852:	00004597          	auipc	a1,0x4
    80004856:	e2658593          	addi	a1,a1,-474 # 80008678 <syscalls+0x2b0>
    8000485a:	fb040513          	addi	a0,s0,-80
    8000485e:	ffffe097          	auipc	ra,0xffffe
    80004862:	6ce080e7          	jalr	1742(ra) # 80002f2c <namecmp>
    80004866:	14050a63          	beqz	a0,800049ba <sys_unlink+0x1b0>
    8000486a:	00004597          	auipc	a1,0x4
    8000486e:	e1658593          	addi	a1,a1,-490 # 80008680 <syscalls+0x2b8>
    80004872:	fb040513          	addi	a0,s0,-80
    80004876:	ffffe097          	auipc	ra,0xffffe
    8000487a:	6b6080e7          	jalr	1718(ra) # 80002f2c <namecmp>
    8000487e:	12050e63          	beqz	a0,800049ba <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004882:	f2c40613          	addi	a2,s0,-212
    80004886:	fb040593          	addi	a1,s0,-80
    8000488a:	8526                	mv	a0,s1
    8000488c:	ffffe097          	auipc	ra,0xffffe
    80004890:	6ba080e7          	jalr	1722(ra) # 80002f46 <dirlookup>
    80004894:	892a                	mv	s2,a0
    80004896:	12050263          	beqz	a0,800049ba <sys_unlink+0x1b0>
  ilock(ip);
    8000489a:	ffffe097          	auipc	ra,0xffffe
    8000489e:	1c8080e7          	jalr	456(ra) # 80002a62 <ilock>
  if(ip->nlink < 1)
    800048a2:	04a91783          	lh	a5,74(s2)
    800048a6:	08f05263          	blez	a5,8000492a <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800048aa:	04491703          	lh	a4,68(s2)
    800048ae:	4785                	li	a5,1
    800048b0:	08f70563          	beq	a4,a5,8000493a <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800048b4:	4641                	li	a2,16
    800048b6:	4581                	li	a1,0
    800048b8:	fc040513          	addi	a0,s0,-64
    800048bc:	ffffc097          	auipc	ra,0xffffc
    800048c0:	8bc080e7          	jalr	-1860(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800048c4:	4741                	li	a4,16
    800048c6:	f2c42683          	lw	a3,-212(s0)
    800048ca:	fc040613          	addi	a2,s0,-64
    800048ce:	4581                	li	a1,0
    800048d0:	8526                	mv	a0,s1
    800048d2:	ffffe097          	auipc	ra,0xffffe
    800048d6:	53c080e7          	jalr	1340(ra) # 80002e0e <writei>
    800048da:	47c1                	li	a5,16
    800048dc:	0af51563          	bne	a0,a5,80004986 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800048e0:	04491703          	lh	a4,68(s2)
    800048e4:	4785                	li	a5,1
    800048e6:	0af70863          	beq	a4,a5,80004996 <sys_unlink+0x18c>
  iunlockput(dp);
    800048ea:	8526                	mv	a0,s1
    800048ec:	ffffe097          	auipc	ra,0xffffe
    800048f0:	3d8080e7          	jalr	984(ra) # 80002cc4 <iunlockput>
  ip->nlink--;
    800048f4:	04a95783          	lhu	a5,74(s2)
    800048f8:	37fd                	addiw	a5,a5,-1
    800048fa:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800048fe:	854a                	mv	a0,s2
    80004900:	ffffe097          	auipc	ra,0xffffe
    80004904:	098080e7          	jalr	152(ra) # 80002998 <iupdate>
  iunlockput(ip);
    80004908:	854a                	mv	a0,s2
    8000490a:	ffffe097          	auipc	ra,0xffffe
    8000490e:	3ba080e7          	jalr	954(ra) # 80002cc4 <iunlockput>
  end_op();
    80004912:	fffff097          	auipc	ra,0xfffff
    80004916:	ba2080e7          	jalr	-1118(ra) # 800034b4 <end_op>
  return 0;
    8000491a:	4501                	li	a0,0
    8000491c:	a84d                	j	800049ce <sys_unlink+0x1c4>
    end_op();
    8000491e:	fffff097          	auipc	ra,0xfffff
    80004922:	b96080e7          	jalr	-1130(ra) # 800034b4 <end_op>
    return -1;
    80004926:	557d                	li	a0,-1
    80004928:	a05d                	j	800049ce <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    8000492a:	00004517          	auipc	a0,0x4
    8000492e:	d7e50513          	addi	a0,a0,-642 # 800086a8 <syscalls+0x2e0>
    80004932:	00001097          	auipc	ra,0x1
    80004936:	1a2080e7          	jalr	418(ra) # 80005ad4 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000493a:	04c92703          	lw	a4,76(s2)
    8000493e:	02000793          	li	a5,32
    80004942:	f6e7f9e3          	bgeu	a5,a4,800048b4 <sys_unlink+0xaa>
    80004946:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000494a:	4741                	li	a4,16
    8000494c:	86ce                	mv	a3,s3
    8000494e:	f1840613          	addi	a2,s0,-232
    80004952:	4581                	li	a1,0
    80004954:	854a                	mv	a0,s2
    80004956:	ffffe097          	auipc	ra,0xffffe
    8000495a:	3c0080e7          	jalr	960(ra) # 80002d16 <readi>
    8000495e:	47c1                	li	a5,16
    80004960:	00f51b63          	bne	a0,a5,80004976 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004964:	f1845783          	lhu	a5,-232(s0)
    80004968:	e7a1                	bnez	a5,800049b0 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000496a:	29c1                	addiw	s3,s3,16
    8000496c:	04c92783          	lw	a5,76(s2)
    80004970:	fcf9ede3          	bltu	s3,a5,8000494a <sys_unlink+0x140>
    80004974:	b781                	j	800048b4 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004976:	00004517          	auipc	a0,0x4
    8000497a:	d4a50513          	addi	a0,a0,-694 # 800086c0 <syscalls+0x2f8>
    8000497e:	00001097          	auipc	ra,0x1
    80004982:	156080e7          	jalr	342(ra) # 80005ad4 <panic>
    panic("unlink: writei");
    80004986:	00004517          	auipc	a0,0x4
    8000498a:	d5250513          	addi	a0,a0,-686 # 800086d8 <syscalls+0x310>
    8000498e:	00001097          	auipc	ra,0x1
    80004992:	146080e7          	jalr	326(ra) # 80005ad4 <panic>
    dp->nlink--;
    80004996:	04a4d783          	lhu	a5,74(s1)
    8000499a:	37fd                	addiw	a5,a5,-1
    8000499c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800049a0:	8526                	mv	a0,s1
    800049a2:	ffffe097          	auipc	ra,0xffffe
    800049a6:	ff6080e7          	jalr	-10(ra) # 80002998 <iupdate>
    800049aa:	b781                	j	800048ea <sys_unlink+0xe0>
    return -1;
    800049ac:	557d                	li	a0,-1
    800049ae:	a005                	j	800049ce <sys_unlink+0x1c4>
    iunlockput(ip);
    800049b0:	854a                	mv	a0,s2
    800049b2:	ffffe097          	auipc	ra,0xffffe
    800049b6:	312080e7          	jalr	786(ra) # 80002cc4 <iunlockput>
  iunlockput(dp);
    800049ba:	8526                	mv	a0,s1
    800049bc:	ffffe097          	auipc	ra,0xffffe
    800049c0:	308080e7          	jalr	776(ra) # 80002cc4 <iunlockput>
  end_op();
    800049c4:	fffff097          	auipc	ra,0xfffff
    800049c8:	af0080e7          	jalr	-1296(ra) # 800034b4 <end_op>
  return -1;
    800049cc:	557d                	li	a0,-1
}
    800049ce:	70ae                	ld	ra,232(sp)
    800049d0:	740e                	ld	s0,224(sp)
    800049d2:	64ee                	ld	s1,216(sp)
    800049d4:	694e                	ld	s2,208(sp)
    800049d6:	69ae                	ld	s3,200(sp)
    800049d8:	616d                	addi	sp,sp,240
    800049da:	8082                	ret

00000000800049dc <sys_open>:

uint64
sys_open(void)
{
    800049dc:	7131                	addi	sp,sp,-192
    800049de:	fd06                	sd	ra,184(sp)
    800049e0:	f922                	sd	s0,176(sp)
    800049e2:	f526                	sd	s1,168(sp)
    800049e4:	f14a                	sd	s2,160(sp)
    800049e6:	ed4e                	sd	s3,152(sp)
    800049e8:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800049ea:	08000613          	li	a2,128
    800049ee:	f5040593          	addi	a1,s0,-176
    800049f2:	4501                	li	a0,0
    800049f4:	ffffd097          	auipc	ra,0xffffd
    800049f8:	542080e7          	jalr	1346(ra) # 80001f36 <argstr>
    return -1;
    800049fc:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800049fe:	0c054163          	bltz	a0,80004ac0 <sys_open+0xe4>
    80004a02:	f4c40593          	addi	a1,s0,-180
    80004a06:	4505                	li	a0,1
    80004a08:	ffffd097          	auipc	ra,0xffffd
    80004a0c:	4ea080e7          	jalr	1258(ra) # 80001ef2 <argint>
    80004a10:	0a054863          	bltz	a0,80004ac0 <sys_open+0xe4>

  begin_op();
    80004a14:	fffff097          	auipc	ra,0xfffff
    80004a18:	a20080e7          	jalr	-1504(ra) # 80003434 <begin_op>

  if(omode & O_CREATE){
    80004a1c:	f4c42783          	lw	a5,-180(s0)
    80004a20:	2007f793          	andi	a5,a5,512
    80004a24:	cbdd                	beqz	a5,80004ada <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004a26:	4681                	li	a3,0
    80004a28:	4601                	li	a2,0
    80004a2a:	4589                	li	a1,2
    80004a2c:	f5040513          	addi	a0,s0,-176
    80004a30:	00000097          	auipc	ra,0x0
    80004a34:	974080e7          	jalr	-1676(ra) # 800043a4 <create>
    80004a38:	892a                	mv	s2,a0
    if(ip == 0){
    80004a3a:	c959                	beqz	a0,80004ad0 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004a3c:	04491703          	lh	a4,68(s2)
    80004a40:	478d                	li	a5,3
    80004a42:	00f71763          	bne	a4,a5,80004a50 <sys_open+0x74>
    80004a46:	04695703          	lhu	a4,70(s2)
    80004a4a:	47a5                	li	a5,9
    80004a4c:	0ce7ec63          	bltu	a5,a4,80004b24 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004a50:	fffff097          	auipc	ra,0xfffff
    80004a54:	df4080e7          	jalr	-524(ra) # 80003844 <filealloc>
    80004a58:	89aa                	mv	s3,a0
    80004a5a:	10050263          	beqz	a0,80004b5e <sys_open+0x182>
    80004a5e:	00000097          	auipc	ra,0x0
    80004a62:	904080e7          	jalr	-1788(ra) # 80004362 <fdalloc>
    80004a66:	84aa                	mv	s1,a0
    80004a68:	0e054663          	bltz	a0,80004b54 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004a6c:	04491703          	lh	a4,68(s2)
    80004a70:	478d                	li	a5,3
    80004a72:	0cf70463          	beq	a4,a5,80004b3a <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004a76:	4789                	li	a5,2
    80004a78:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004a7c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004a80:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004a84:	f4c42783          	lw	a5,-180(s0)
    80004a88:	0017c713          	xori	a4,a5,1
    80004a8c:	8b05                	andi	a4,a4,1
    80004a8e:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004a92:	0037f713          	andi	a4,a5,3
    80004a96:	00e03733          	snez	a4,a4
    80004a9a:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004a9e:	4007f793          	andi	a5,a5,1024
    80004aa2:	c791                	beqz	a5,80004aae <sys_open+0xd2>
    80004aa4:	04491703          	lh	a4,68(s2)
    80004aa8:	4789                	li	a5,2
    80004aaa:	08f70f63          	beq	a4,a5,80004b48 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004aae:	854a                	mv	a0,s2
    80004ab0:	ffffe097          	auipc	ra,0xffffe
    80004ab4:	074080e7          	jalr	116(ra) # 80002b24 <iunlock>
  end_op();
    80004ab8:	fffff097          	auipc	ra,0xfffff
    80004abc:	9fc080e7          	jalr	-1540(ra) # 800034b4 <end_op>

  return fd;
}
    80004ac0:	8526                	mv	a0,s1
    80004ac2:	70ea                	ld	ra,184(sp)
    80004ac4:	744a                	ld	s0,176(sp)
    80004ac6:	74aa                	ld	s1,168(sp)
    80004ac8:	790a                	ld	s2,160(sp)
    80004aca:	69ea                	ld	s3,152(sp)
    80004acc:	6129                	addi	sp,sp,192
    80004ace:	8082                	ret
      end_op();
    80004ad0:	fffff097          	auipc	ra,0xfffff
    80004ad4:	9e4080e7          	jalr	-1564(ra) # 800034b4 <end_op>
      return -1;
    80004ad8:	b7e5                	j	80004ac0 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004ada:	f5040513          	addi	a0,s0,-176
    80004ade:	ffffe097          	auipc	ra,0xffffe
    80004ae2:	73a080e7          	jalr	1850(ra) # 80003218 <namei>
    80004ae6:	892a                	mv	s2,a0
    80004ae8:	c905                	beqz	a0,80004b18 <sys_open+0x13c>
    ilock(ip);
    80004aea:	ffffe097          	auipc	ra,0xffffe
    80004aee:	f78080e7          	jalr	-136(ra) # 80002a62 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004af2:	04491703          	lh	a4,68(s2)
    80004af6:	4785                	li	a5,1
    80004af8:	f4f712e3          	bne	a4,a5,80004a3c <sys_open+0x60>
    80004afc:	f4c42783          	lw	a5,-180(s0)
    80004b00:	dba1                	beqz	a5,80004a50 <sys_open+0x74>
      iunlockput(ip);
    80004b02:	854a                	mv	a0,s2
    80004b04:	ffffe097          	auipc	ra,0xffffe
    80004b08:	1c0080e7          	jalr	448(ra) # 80002cc4 <iunlockput>
      end_op();
    80004b0c:	fffff097          	auipc	ra,0xfffff
    80004b10:	9a8080e7          	jalr	-1624(ra) # 800034b4 <end_op>
      return -1;
    80004b14:	54fd                	li	s1,-1
    80004b16:	b76d                	j	80004ac0 <sys_open+0xe4>
      end_op();
    80004b18:	fffff097          	auipc	ra,0xfffff
    80004b1c:	99c080e7          	jalr	-1636(ra) # 800034b4 <end_op>
      return -1;
    80004b20:	54fd                	li	s1,-1
    80004b22:	bf79                	j	80004ac0 <sys_open+0xe4>
    iunlockput(ip);
    80004b24:	854a                	mv	a0,s2
    80004b26:	ffffe097          	auipc	ra,0xffffe
    80004b2a:	19e080e7          	jalr	414(ra) # 80002cc4 <iunlockput>
    end_op();
    80004b2e:	fffff097          	auipc	ra,0xfffff
    80004b32:	986080e7          	jalr	-1658(ra) # 800034b4 <end_op>
    return -1;
    80004b36:	54fd                	li	s1,-1
    80004b38:	b761                	j	80004ac0 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004b3a:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004b3e:	04691783          	lh	a5,70(s2)
    80004b42:	02f99223          	sh	a5,36(s3)
    80004b46:	bf2d                	j	80004a80 <sys_open+0xa4>
    itrunc(ip);
    80004b48:	854a                	mv	a0,s2
    80004b4a:	ffffe097          	auipc	ra,0xffffe
    80004b4e:	026080e7          	jalr	38(ra) # 80002b70 <itrunc>
    80004b52:	bfb1                	j	80004aae <sys_open+0xd2>
      fileclose(f);
    80004b54:	854e                	mv	a0,s3
    80004b56:	fffff097          	auipc	ra,0xfffff
    80004b5a:	daa080e7          	jalr	-598(ra) # 80003900 <fileclose>
    iunlockput(ip);
    80004b5e:	854a                	mv	a0,s2
    80004b60:	ffffe097          	auipc	ra,0xffffe
    80004b64:	164080e7          	jalr	356(ra) # 80002cc4 <iunlockput>
    end_op();
    80004b68:	fffff097          	auipc	ra,0xfffff
    80004b6c:	94c080e7          	jalr	-1716(ra) # 800034b4 <end_op>
    return -1;
    80004b70:	54fd                	li	s1,-1
    80004b72:	b7b9                	j	80004ac0 <sys_open+0xe4>

0000000080004b74 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004b74:	7175                	addi	sp,sp,-144
    80004b76:	e506                	sd	ra,136(sp)
    80004b78:	e122                	sd	s0,128(sp)
    80004b7a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004b7c:	fffff097          	auipc	ra,0xfffff
    80004b80:	8b8080e7          	jalr	-1864(ra) # 80003434 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004b84:	08000613          	li	a2,128
    80004b88:	f7040593          	addi	a1,s0,-144
    80004b8c:	4501                	li	a0,0
    80004b8e:	ffffd097          	auipc	ra,0xffffd
    80004b92:	3a8080e7          	jalr	936(ra) # 80001f36 <argstr>
    80004b96:	02054963          	bltz	a0,80004bc8 <sys_mkdir+0x54>
    80004b9a:	4681                	li	a3,0
    80004b9c:	4601                	li	a2,0
    80004b9e:	4585                	li	a1,1
    80004ba0:	f7040513          	addi	a0,s0,-144
    80004ba4:	00000097          	auipc	ra,0x0
    80004ba8:	800080e7          	jalr	-2048(ra) # 800043a4 <create>
    80004bac:	cd11                	beqz	a0,80004bc8 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004bae:	ffffe097          	auipc	ra,0xffffe
    80004bb2:	116080e7          	jalr	278(ra) # 80002cc4 <iunlockput>
  end_op();
    80004bb6:	fffff097          	auipc	ra,0xfffff
    80004bba:	8fe080e7          	jalr	-1794(ra) # 800034b4 <end_op>
  return 0;
    80004bbe:	4501                	li	a0,0
}
    80004bc0:	60aa                	ld	ra,136(sp)
    80004bc2:	640a                	ld	s0,128(sp)
    80004bc4:	6149                	addi	sp,sp,144
    80004bc6:	8082                	ret
    end_op();
    80004bc8:	fffff097          	auipc	ra,0xfffff
    80004bcc:	8ec080e7          	jalr	-1812(ra) # 800034b4 <end_op>
    return -1;
    80004bd0:	557d                	li	a0,-1
    80004bd2:	b7fd                	j	80004bc0 <sys_mkdir+0x4c>

0000000080004bd4 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004bd4:	7135                	addi	sp,sp,-160
    80004bd6:	ed06                	sd	ra,152(sp)
    80004bd8:	e922                	sd	s0,144(sp)
    80004bda:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004bdc:	fffff097          	auipc	ra,0xfffff
    80004be0:	858080e7          	jalr	-1960(ra) # 80003434 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004be4:	08000613          	li	a2,128
    80004be8:	f7040593          	addi	a1,s0,-144
    80004bec:	4501                	li	a0,0
    80004bee:	ffffd097          	auipc	ra,0xffffd
    80004bf2:	348080e7          	jalr	840(ra) # 80001f36 <argstr>
    80004bf6:	04054a63          	bltz	a0,80004c4a <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004bfa:	f6c40593          	addi	a1,s0,-148
    80004bfe:	4505                	li	a0,1
    80004c00:	ffffd097          	auipc	ra,0xffffd
    80004c04:	2f2080e7          	jalr	754(ra) # 80001ef2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004c08:	04054163          	bltz	a0,80004c4a <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004c0c:	f6840593          	addi	a1,s0,-152
    80004c10:	4509                	li	a0,2
    80004c12:	ffffd097          	auipc	ra,0xffffd
    80004c16:	2e0080e7          	jalr	736(ra) # 80001ef2 <argint>
     argint(1, &major) < 0 ||
    80004c1a:	02054863          	bltz	a0,80004c4a <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004c1e:	f6841683          	lh	a3,-152(s0)
    80004c22:	f6c41603          	lh	a2,-148(s0)
    80004c26:	458d                	li	a1,3
    80004c28:	f7040513          	addi	a0,s0,-144
    80004c2c:	fffff097          	auipc	ra,0xfffff
    80004c30:	778080e7          	jalr	1912(ra) # 800043a4 <create>
     argint(2, &minor) < 0 ||
    80004c34:	c919                	beqz	a0,80004c4a <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004c36:	ffffe097          	auipc	ra,0xffffe
    80004c3a:	08e080e7          	jalr	142(ra) # 80002cc4 <iunlockput>
  end_op();
    80004c3e:	fffff097          	auipc	ra,0xfffff
    80004c42:	876080e7          	jalr	-1930(ra) # 800034b4 <end_op>
  return 0;
    80004c46:	4501                	li	a0,0
    80004c48:	a031                	j	80004c54 <sys_mknod+0x80>
    end_op();
    80004c4a:	fffff097          	auipc	ra,0xfffff
    80004c4e:	86a080e7          	jalr	-1942(ra) # 800034b4 <end_op>
    return -1;
    80004c52:	557d                	li	a0,-1
}
    80004c54:	60ea                	ld	ra,152(sp)
    80004c56:	644a                	ld	s0,144(sp)
    80004c58:	610d                	addi	sp,sp,160
    80004c5a:	8082                	ret

0000000080004c5c <sys_chdir>:

uint64
sys_chdir(void)
{
    80004c5c:	7135                	addi	sp,sp,-160
    80004c5e:	ed06                	sd	ra,152(sp)
    80004c60:	e922                	sd	s0,144(sp)
    80004c62:	e526                	sd	s1,136(sp)
    80004c64:	e14a                	sd	s2,128(sp)
    80004c66:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004c68:	ffffc097          	auipc	ra,0xffffc
    80004c6c:	1da080e7          	jalr	474(ra) # 80000e42 <myproc>
    80004c70:	892a                	mv	s2,a0
  
  begin_op();
    80004c72:	ffffe097          	auipc	ra,0xffffe
    80004c76:	7c2080e7          	jalr	1986(ra) # 80003434 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004c7a:	08000613          	li	a2,128
    80004c7e:	f6040593          	addi	a1,s0,-160
    80004c82:	4501                	li	a0,0
    80004c84:	ffffd097          	auipc	ra,0xffffd
    80004c88:	2b2080e7          	jalr	690(ra) # 80001f36 <argstr>
    80004c8c:	04054b63          	bltz	a0,80004ce2 <sys_chdir+0x86>
    80004c90:	f6040513          	addi	a0,s0,-160
    80004c94:	ffffe097          	auipc	ra,0xffffe
    80004c98:	584080e7          	jalr	1412(ra) # 80003218 <namei>
    80004c9c:	84aa                	mv	s1,a0
    80004c9e:	c131                	beqz	a0,80004ce2 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004ca0:	ffffe097          	auipc	ra,0xffffe
    80004ca4:	dc2080e7          	jalr	-574(ra) # 80002a62 <ilock>
  if(ip->type != T_DIR){
    80004ca8:	04449703          	lh	a4,68(s1)
    80004cac:	4785                	li	a5,1
    80004cae:	04f71063          	bne	a4,a5,80004cee <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004cb2:	8526                	mv	a0,s1
    80004cb4:	ffffe097          	auipc	ra,0xffffe
    80004cb8:	e70080e7          	jalr	-400(ra) # 80002b24 <iunlock>
  iput(p->cwd);
    80004cbc:	15093503          	ld	a0,336(s2)
    80004cc0:	ffffe097          	auipc	ra,0xffffe
    80004cc4:	f5c080e7          	jalr	-164(ra) # 80002c1c <iput>
  end_op();
    80004cc8:	ffffe097          	auipc	ra,0xffffe
    80004ccc:	7ec080e7          	jalr	2028(ra) # 800034b4 <end_op>
  p->cwd = ip;
    80004cd0:	14993823          	sd	s1,336(s2)
  return 0;
    80004cd4:	4501                	li	a0,0
}
    80004cd6:	60ea                	ld	ra,152(sp)
    80004cd8:	644a                	ld	s0,144(sp)
    80004cda:	64aa                	ld	s1,136(sp)
    80004cdc:	690a                	ld	s2,128(sp)
    80004cde:	610d                	addi	sp,sp,160
    80004ce0:	8082                	ret
    end_op();
    80004ce2:	ffffe097          	auipc	ra,0xffffe
    80004ce6:	7d2080e7          	jalr	2002(ra) # 800034b4 <end_op>
    return -1;
    80004cea:	557d                	li	a0,-1
    80004cec:	b7ed                	j	80004cd6 <sys_chdir+0x7a>
    iunlockput(ip);
    80004cee:	8526                	mv	a0,s1
    80004cf0:	ffffe097          	auipc	ra,0xffffe
    80004cf4:	fd4080e7          	jalr	-44(ra) # 80002cc4 <iunlockput>
    end_op();
    80004cf8:	ffffe097          	auipc	ra,0xffffe
    80004cfc:	7bc080e7          	jalr	1980(ra) # 800034b4 <end_op>
    return -1;
    80004d00:	557d                	li	a0,-1
    80004d02:	bfd1                	j	80004cd6 <sys_chdir+0x7a>

0000000080004d04 <sys_exec>:

uint64
sys_exec(void)
{
    80004d04:	7145                	addi	sp,sp,-464
    80004d06:	e786                	sd	ra,456(sp)
    80004d08:	e3a2                	sd	s0,448(sp)
    80004d0a:	ff26                	sd	s1,440(sp)
    80004d0c:	fb4a                	sd	s2,432(sp)
    80004d0e:	f74e                	sd	s3,424(sp)
    80004d10:	f352                	sd	s4,416(sp)
    80004d12:	ef56                	sd	s5,408(sp)
    80004d14:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004d16:	08000613          	li	a2,128
    80004d1a:	f4040593          	addi	a1,s0,-192
    80004d1e:	4501                	li	a0,0
    80004d20:	ffffd097          	auipc	ra,0xffffd
    80004d24:	216080e7          	jalr	534(ra) # 80001f36 <argstr>
    return -1;
    80004d28:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004d2a:	0c054a63          	bltz	a0,80004dfe <sys_exec+0xfa>
    80004d2e:	e3840593          	addi	a1,s0,-456
    80004d32:	4505                	li	a0,1
    80004d34:	ffffd097          	auipc	ra,0xffffd
    80004d38:	1e0080e7          	jalr	480(ra) # 80001f14 <argaddr>
    80004d3c:	0c054163          	bltz	a0,80004dfe <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004d40:	10000613          	li	a2,256
    80004d44:	4581                	li	a1,0
    80004d46:	e4040513          	addi	a0,s0,-448
    80004d4a:	ffffb097          	auipc	ra,0xffffb
    80004d4e:	42e080e7          	jalr	1070(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004d52:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004d56:	89a6                	mv	s3,s1
    80004d58:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004d5a:	02000a13          	li	s4,32
    80004d5e:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004d62:	00391793          	slli	a5,s2,0x3
    80004d66:	e3040593          	addi	a1,s0,-464
    80004d6a:	e3843503          	ld	a0,-456(s0)
    80004d6e:	953e                	add	a0,a0,a5
    80004d70:	ffffd097          	auipc	ra,0xffffd
    80004d74:	0e8080e7          	jalr	232(ra) # 80001e58 <fetchaddr>
    80004d78:	02054a63          	bltz	a0,80004dac <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004d7c:	e3043783          	ld	a5,-464(s0)
    80004d80:	c3b9                	beqz	a5,80004dc6 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004d82:	ffffb097          	auipc	ra,0xffffb
    80004d86:	396080e7          	jalr	918(ra) # 80000118 <kalloc>
    80004d8a:	85aa                	mv	a1,a0
    80004d8c:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004d90:	cd11                	beqz	a0,80004dac <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004d92:	6605                	lui	a2,0x1
    80004d94:	e3043503          	ld	a0,-464(s0)
    80004d98:	ffffd097          	auipc	ra,0xffffd
    80004d9c:	112080e7          	jalr	274(ra) # 80001eaa <fetchstr>
    80004da0:	00054663          	bltz	a0,80004dac <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004da4:	0905                	addi	s2,s2,1
    80004da6:	09a1                	addi	s3,s3,8
    80004da8:	fb491be3          	bne	s2,s4,80004d5e <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004dac:	10048913          	addi	s2,s1,256
    80004db0:	6088                	ld	a0,0(s1)
    80004db2:	c529                	beqz	a0,80004dfc <sys_exec+0xf8>
    kfree(argv[i]);
    80004db4:	ffffb097          	auipc	ra,0xffffb
    80004db8:	268080e7          	jalr	616(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004dbc:	04a1                	addi	s1,s1,8
    80004dbe:	ff2499e3          	bne	s1,s2,80004db0 <sys_exec+0xac>
  return -1;
    80004dc2:	597d                	li	s2,-1
    80004dc4:	a82d                	j	80004dfe <sys_exec+0xfa>
      argv[i] = 0;
    80004dc6:	0a8e                	slli	s5,s5,0x3
    80004dc8:	fc040793          	addi	a5,s0,-64
    80004dcc:	9abe                	add	s5,s5,a5
    80004dce:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd8c40>
  int ret = exec(path, argv);
    80004dd2:	e4040593          	addi	a1,s0,-448
    80004dd6:	f4040513          	addi	a0,s0,-192
    80004dda:	fffff097          	auipc	ra,0xfffff
    80004dde:	178080e7          	jalr	376(ra) # 80003f52 <exec>
    80004de2:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004de4:	10048993          	addi	s3,s1,256
    80004de8:	6088                	ld	a0,0(s1)
    80004dea:	c911                	beqz	a0,80004dfe <sys_exec+0xfa>
    kfree(argv[i]);
    80004dec:	ffffb097          	auipc	ra,0xffffb
    80004df0:	230080e7          	jalr	560(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004df4:	04a1                	addi	s1,s1,8
    80004df6:	ff3499e3          	bne	s1,s3,80004de8 <sys_exec+0xe4>
    80004dfa:	a011                	j	80004dfe <sys_exec+0xfa>
  return -1;
    80004dfc:	597d                	li	s2,-1
}
    80004dfe:	854a                	mv	a0,s2
    80004e00:	60be                	ld	ra,456(sp)
    80004e02:	641e                	ld	s0,448(sp)
    80004e04:	74fa                	ld	s1,440(sp)
    80004e06:	795a                	ld	s2,432(sp)
    80004e08:	79ba                	ld	s3,424(sp)
    80004e0a:	7a1a                	ld	s4,416(sp)
    80004e0c:	6afa                	ld	s5,408(sp)
    80004e0e:	6179                	addi	sp,sp,464
    80004e10:	8082                	ret

0000000080004e12 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004e12:	7139                	addi	sp,sp,-64
    80004e14:	fc06                	sd	ra,56(sp)
    80004e16:	f822                	sd	s0,48(sp)
    80004e18:	f426                	sd	s1,40(sp)
    80004e1a:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004e1c:	ffffc097          	auipc	ra,0xffffc
    80004e20:	026080e7          	jalr	38(ra) # 80000e42 <myproc>
    80004e24:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004e26:	fd840593          	addi	a1,s0,-40
    80004e2a:	4501                	li	a0,0
    80004e2c:	ffffd097          	auipc	ra,0xffffd
    80004e30:	0e8080e7          	jalr	232(ra) # 80001f14 <argaddr>
    return -1;
    80004e34:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004e36:	0e054063          	bltz	a0,80004f16 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004e3a:	fc840593          	addi	a1,s0,-56
    80004e3e:	fd040513          	addi	a0,s0,-48
    80004e42:	fffff097          	auipc	ra,0xfffff
    80004e46:	dee080e7          	jalr	-530(ra) # 80003c30 <pipealloc>
    return -1;
    80004e4a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004e4c:	0c054563          	bltz	a0,80004f16 <sys_pipe+0x104>
  fd0 = -1;
    80004e50:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004e54:	fd043503          	ld	a0,-48(s0)
    80004e58:	fffff097          	auipc	ra,0xfffff
    80004e5c:	50a080e7          	jalr	1290(ra) # 80004362 <fdalloc>
    80004e60:	fca42223          	sw	a0,-60(s0)
    80004e64:	08054c63          	bltz	a0,80004efc <sys_pipe+0xea>
    80004e68:	fc843503          	ld	a0,-56(s0)
    80004e6c:	fffff097          	auipc	ra,0xfffff
    80004e70:	4f6080e7          	jalr	1270(ra) # 80004362 <fdalloc>
    80004e74:	fca42023          	sw	a0,-64(s0)
    80004e78:	06054863          	bltz	a0,80004ee8 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004e7c:	4691                	li	a3,4
    80004e7e:	fc440613          	addi	a2,s0,-60
    80004e82:	fd843583          	ld	a1,-40(s0)
    80004e86:	68a8                	ld	a0,80(s1)
    80004e88:	ffffc097          	auipc	ra,0xffffc
    80004e8c:	c7a080e7          	jalr	-902(ra) # 80000b02 <copyout>
    80004e90:	02054063          	bltz	a0,80004eb0 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004e94:	4691                	li	a3,4
    80004e96:	fc040613          	addi	a2,s0,-64
    80004e9a:	fd843583          	ld	a1,-40(s0)
    80004e9e:	0591                	addi	a1,a1,4
    80004ea0:	68a8                	ld	a0,80(s1)
    80004ea2:	ffffc097          	auipc	ra,0xffffc
    80004ea6:	c60080e7          	jalr	-928(ra) # 80000b02 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004eaa:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004eac:	06055563          	bgez	a0,80004f16 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80004eb0:	fc442783          	lw	a5,-60(s0)
    80004eb4:	07e9                	addi	a5,a5,26
    80004eb6:	078e                	slli	a5,a5,0x3
    80004eb8:	97a6                	add	a5,a5,s1
    80004eba:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004ebe:	fc042503          	lw	a0,-64(s0)
    80004ec2:	0569                	addi	a0,a0,26
    80004ec4:	050e                	slli	a0,a0,0x3
    80004ec6:	9526                	add	a0,a0,s1
    80004ec8:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80004ecc:	fd043503          	ld	a0,-48(s0)
    80004ed0:	fffff097          	auipc	ra,0xfffff
    80004ed4:	a30080e7          	jalr	-1488(ra) # 80003900 <fileclose>
    fileclose(wf);
    80004ed8:	fc843503          	ld	a0,-56(s0)
    80004edc:	fffff097          	auipc	ra,0xfffff
    80004ee0:	a24080e7          	jalr	-1500(ra) # 80003900 <fileclose>
    return -1;
    80004ee4:	57fd                	li	a5,-1
    80004ee6:	a805                	j	80004f16 <sys_pipe+0x104>
    if(fd0 >= 0)
    80004ee8:	fc442783          	lw	a5,-60(s0)
    80004eec:	0007c863          	bltz	a5,80004efc <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80004ef0:	01a78513          	addi	a0,a5,26
    80004ef4:	050e                	slli	a0,a0,0x3
    80004ef6:	9526                	add	a0,a0,s1
    80004ef8:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80004efc:	fd043503          	ld	a0,-48(s0)
    80004f00:	fffff097          	auipc	ra,0xfffff
    80004f04:	a00080e7          	jalr	-1536(ra) # 80003900 <fileclose>
    fileclose(wf);
    80004f08:	fc843503          	ld	a0,-56(s0)
    80004f0c:	fffff097          	auipc	ra,0xfffff
    80004f10:	9f4080e7          	jalr	-1548(ra) # 80003900 <fileclose>
    return -1;
    80004f14:	57fd                	li	a5,-1
}
    80004f16:	853e                	mv	a0,a5
    80004f18:	70e2                	ld	ra,56(sp)
    80004f1a:	7442                	ld	s0,48(sp)
    80004f1c:	74a2                	ld	s1,40(sp)
    80004f1e:	6121                	addi	sp,sp,64
    80004f20:	8082                	ret
	...

0000000080004f30 <kernelvec>:
    80004f30:	7111                	addi	sp,sp,-256
    80004f32:	e006                	sd	ra,0(sp)
    80004f34:	e40a                	sd	sp,8(sp)
    80004f36:	e80e                	sd	gp,16(sp)
    80004f38:	ec12                	sd	tp,24(sp)
    80004f3a:	f016                	sd	t0,32(sp)
    80004f3c:	f41a                	sd	t1,40(sp)
    80004f3e:	f81e                	sd	t2,48(sp)
    80004f40:	fc22                	sd	s0,56(sp)
    80004f42:	e0a6                	sd	s1,64(sp)
    80004f44:	e4aa                	sd	a0,72(sp)
    80004f46:	e8ae                	sd	a1,80(sp)
    80004f48:	ecb2                	sd	a2,88(sp)
    80004f4a:	f0b6                	sd	a3,96(sp)
    80004f4c:	f4ba                	sd	a4,104(sp)
    80004f4e:	f8be                	sd	a5,112(sp)
    80004f50:	fcc2                	sd	a6,120(sp)
    80004f52:	e146                	sd	a7,128(sp)
    80004f54:	e54a                	sd	s2,136(sp)
    80004f56:	e94e                	sd	s3,144(sp)
    80004f58:	ed52                	sd	s4,152(sp)
    80004f5a:	f156                	sd	s5,160(sp)
    80004f5c:	f55a                	sd	s6,168(sp)
    80004f5e:	f95e                	sd	s7,176(sp)
    80004f60:	fd62                	sd	s8,184(sp)
    80004f62:	e1e6                	sd	s9,192(sp)
    80004f64:	e5ea                	sd	s10,200(sp)
    80004f66:	e9ee                	sd	s11,208(sp)
    80004f68:	edf2                	sd	t3,216(sp)
    80004f6a:	f1f6                	sd	t4,224(sp)
    80004f6c:	f5fa                	sd	t5,232(sp)
    80004f6e:	f9fe                	sd	t6,240(sp)
    80004f70:	db5fc0ef          	jal	ra,80001d24 <kerneltrap>
    80004f74:	6082                	ld	ra,0(sp)
    80004f76:	6122                	ld	sp,8(sp)
    80004f78:	61c2                	ld	gp,16(sp)
    80004f7a:	7282                	ld	t0,32(sp)
    80004f7c:	7322                	ld	t1,40(sp)
    80004f7e:	73c2                	ld	t2,48(sp)
    80004f80:	7462                	ld	s0,56(sp)
    80004f82:	6486                	ld	s1,64(sp)
    80004f84:	6526                	ld	a0,72(sp)
    80004f86:	65c6                	ld	a1,80(sp)
    80004f88:	6666                	ld	a2,88(sp)
    80004f8a:	7686                	ld	a3,96(sp)
    80004f8c:	7726                	ld	a4,104(sp)
    80004f8e:	77c6                	ld	a5,112(sp)
    80004f90:	7866                	ld	a6,120(sp)
    80004f92:	688a                	ld	a7,128(sp)
    80004f94:	692a                	ld	s2,136(sp)
    80004f96:	69ca                	ld	s3,144(sp)
    80004f98:	6a6a                	ld	s4,152(sp)
    80004f9a:	7a8a                	ld	s5,160(sp)
    80004f9c:	7b2a                	ld	s6,168(sp)
    80004f9e:	7bca                	ld	s7,176(sp)
    80004fa0:	7c6a                	ld	s8,184(sp)
    80004fa2:	6c8e                	ld	s9,192(sp)
    80004fa4:	6d2e                	ld	s10,200(sp)
    80004fa6:	6dce                	ld	s11,208(sp)
    80004fa8:	6e6e                	ld	t3,216(sp)
    80004faa:	7e8e                	ld	t4,224(sp)
    80004fac:	7f2e                	ld	t5,232(sp)
    80004fae:	7fce                	ld	t6,240(sp)
    80004fb0:	6111                	addi	sp,sp,256
    80004fb2:	10200073          	sret
    80004fb6:	00000013          	nop
    80004fba:	00000013          	nop
    80004fbe:	0001                	nop

0000000080004fc0 <timervec>:
    80004fc0:	34051573          	csrrw	a0,mscratch,a0
    80004fc4:	e10c                	sd	a1,0(a0)
    80004fc6:	e510                	sd	a2,8(a0)
    80004fc8:	e914                	sd	a3,16(a0)
    80004fca:	6d0c                	ld	a1,24(a0)
    80004fcc:	7110                	ld	a2,32(a0)
    80004fce:	6194                	ld	a3,0(a1)
    80004fd0:	96b2                	add	a3,a3,a2
    80004fd2:	e194                	sd	a3,0(a1)
    80004fd4:	4589                	li	a1,2
    80004fd6:	14459073          	csrw	sip,a1
    80004fda:	6914                	ld	a3,16(a0)
    80004fdc:	6510                	ld	a2,8(a0)
    80004fde:	610c                	ld	a1,0(a0)
    80004fe0:	34051573          	csrrw	a0,mscratch,a0
    80004fe4:	30200073          	mret
	...

0000000080004fea <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80004fea:	1141                	addi	sp,sp,-16
    80004fec:	e422                	sd	s0,8(sp)
    80004fee:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004ff0:	0c0007b7          	lui	a5,0xc000
    80004ff4:	4705                	li	a4,1
    80004ff6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80004ff8:	c3d8                	sw	a4,4(a5)
}
    80004ffa:	6422                	ld	s0,8(sp)
    80004ffc:	0141                	addi	sp,sp,16
    80004ffe:	8082                	ret

0000000080005000 <plicinithart>:

void
plicinithart(void)
{
    80005000:	1141                	addi	sp,sp,-16
    80005002:	e406                	sd	ra,8(sp)
    80005004:	e022                	sd	s0,0(sp)
    80005006:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005008:	ffffc097          	auipc	ra,0xffffc
    8000500c:	e0e080e7          	jalr	-498(ra) # 80000e16 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005010:	0085171b          	slliw	a4,a0,0x8
    80005014:	0c0027b7          	lui	a5,0xc002
    80005018:	97ba                	add	a5,a5,a4
    8000501a:	40200713          	li	a4,1026
    8000501e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005022:	00d5151b          	slliw	a0,a0,0xd
    80005026:	0c2017b7          	lui	a5,0xc201
    8000502a:	953e                	add	a0,a0,a5
    8000502c:	00052023          	sw	zero,0(a0)
}
    80005030:	60a2                	ld	ra,8(sp)
    80005032:	6402                	ld	s0,0(sp)
    80005034:	0141                	addi	sp,sp,16
    80005036:	8082                	ret

0000000080005038 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005038:	1141                	addi	sp,sp,-16
    8000503a:	e406                	sd	ra,8(sp)
    8000503c:	e022                	sd	s0,0(sp)
    8000503e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005040:	ffffc097          	auipc	ra,0xffffc
    80005044:	dd6080e7          	jalr	-554(ra) # 80000e16 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005048:	00d5179b          	slliw	a5,a0,0xd
    8000504c:	0c201537          	lui	a0,0xc201
    80005050:	953e                	add	a0,a0,a5
  return irq;
}
    80005052:	4148                	lw	a0,4(a0)
    80005054:	60a2                	ld	ra,8(sp)
    80005056:	6402                	ld	s0,0(sp)
    80005058:	0141                	addi	sp,sp,16
    8000505a:	8082                	ret

000000008000505c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000505c:	1101                	addi	sp,sp,-32
    8000505e:	ec06                	sd	ra,24(sp)
    80005060:	e822                	sd	s0,16(sp)
    80005062:	e426                	sd	s1,8(sp)
    80005064:	1000                	addi	s0,sp,32
    80005066:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005068:	ffffc097          	auipc	ra,0xffffc
    8000506c:	dae080e7          	jalr	-594(ra) # 80000e16 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005070:	00d5151b          	slliw	a0,a0,0xd
    80005074:	0c2017b7          	lui	a5,0xc201
    80005078:	97aa                	add	a5,a5,a0
    8000507a:	c3c4                	sw	s1,4(a5)
}
    8000507c:	60e2                	ld	ra,24(sp)
    8000507e:	6442                	ld	s0,16(sp)
    80005080:	64a2                	ld	s1,8(sp)
    80005082:	6105                	addi	sp,sp,32
    80005084:	8082                	ret

0000000080005086 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005086:	1141                	addi	sp,sp,-16
    80005088:	e406                	sd	ra,8(sp)
    8000508a:	e022                	sd	s0,0(sp)
    8000508c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000508e:	479d                	li	a5,7
    80005090:	06a7c963          	blt	a5,a0,80005102 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005094:	00016797          	auipc	a5,0x16
    80005098:	f6c78793          	addi	a5,a5,-148 # 8001b000 <disk>
    8000509c:	00a78733          	add	a4,a5,a0
    800050a0:	6789                	lui	a5,0x2
    800050a2:	97ba                	add	a5,a5,a4
    800050a4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800050a8:	e7ad                	bnez	a5,80005112 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800050aa:	00451793          	slli	a5,a0,0x4
    800050ae:	00018717          	auipc	a4,0x18
    800050b2:	f5270713          	addi	a4,a4,-174 # 8001d000 <disk+0x2000>
    800050b6:	6314                	ld	a3,0(a4)
    800050b8:	96be                	add	a3,a3,a5
    800050ba:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800050be:	6314                	ld	a3,0(a4)
    800050c0:	96be                	add	a3,a3,a5
    800050c2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800050c6:	6314                	ld	a3,0(a4)
    800050c8:	96be                	add	a3,a3,a5
    800050ca:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800050ce:	6318                	ld	a4,0(a4)
    800050d0:	97ba                	add	a5,a5,a4
    800050d2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800050d6:	00016797          	auipc	a5,0x16
    800050da:	f2a78793          	addi	a5,a5,-214 # 8001b000 <disk>
    800050de:	97aa                	add	a5,a5,a0
    800050e0:	6509                	lui	a0,0x2
    800050e2:	953e                	add	a0,a0,a5
    800050e4:	4785                	li	a5,1
    800050e6:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800050ea:	00018517          	auipc	a0,0x18
    800050ee:	f2e50513          	addi	a0,a0,-210 # 8001d018 <disk+0x2018>
    800050f2:	ffffc097          	auipc	ra,0xffffc
    800050f6:	59c080e7          	jalr	1436(ra) # 8000168e <wakeup>
}
    800050fa:	60a2                	ld	ra,8(sp)
    800050fc:	6402                	ld	s0,0(sp)
    800050fe:	0141                	addi	sp,sp,16
    80005100:	8082                	ret
    panic("free_desc 1");
    80005102:	00003517          	auipc	a0,0x3
    80005106:	5e650513          	addi	a0,a0,1510 # 800086e8 <syscalls+0x320>
    8000510a:	00001097          	auipc	ra,0x1
    8000510e:	9ca080e7          	jalr	-1590(ra) # 80005ad4 <panic>
    panic("free_desc 2");
    80005112:	00003517          	auipc	a0,0x3
    80005116:	5e650513          	addi	a0,a0,1510 # 800086f8 <syscalls+0x330>
    8000511a:	00001097          	auipc	ra,0x1
    8000511e:	9ba080e7          	jalr	-1606(ra) # 80005ad4 <panic>

0000000080005122 <virtio_disk_init>:
{
    80005122:	1101                	addi	sp,sp,-32
    80005124:	ec06                	sd	ra,24(sp)
    80005126:	e822                	sd	s0,16(sp)
    80005128:	e426                	sd	s1,8(sp)
    8000512a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000512c:	00003597          	auipc	a1,0x3
    80005130:	5dc58593          	addi	a1,a1,1500 # 80008708 <syscalls+0x340>
    80005134:	00018517          	auipc	a0,0x18
    80005138:	ff450513          	addi	a0,a0,-12 # 8001d128 <disk+0x2128>
    8000513c:	00001097          	auipc	ra,0x1
    80005140:	e44080e7          	jalr	-444(ra) # 80005f80 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005144:	100017b7          	lui	a5,0x10001
    80005148:	4398                	lw	a4,0(a5)
    8000514a:	2701                	sext.w	a4,a4
    8000514c:	747277b7          	lui	a5,0x74727
    80005150:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005154:	0ef71163          	bne	a4,a5,80005236 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005158:	100017b7          	lui	a5,0x10001
    8000515c:	43dc                	lw	a5,4(a5)
    8000515e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005160:	4705                	li	a4,1
    80005162:	0ce79a63          	bne	a5,a4,80005236 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005166:	100017b7          	lui	a5,0x10001
    8000516a:	479c                	lw	a5,8(a5)
    8000516c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000516e:	4709                	li	a4,2
    80005170:	0ce79363          	bne	a5,a4,80005236 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005174:	100017b7          	lui	a5,0x10001
    80005178:	47d8                	lw	a4,12(a5)
    8000517a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000517c:	554d47b7          	lui	a5,0x554d4
    80005180:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005184:	0af71963          	bne	a4,a5,80005236 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005188:	100017b7          	lui	a5,0x10001
    8000518c:	4705                	li	a4,1
    8000518e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005190:	470d                	li	a4,3
    80005192:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005194:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005196:	c7ffe737          	lui	a4,0xc7ffe
    8000519a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000519e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800051a0:	2701                	sext.w	a4,a4
    800051a2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800051a4:	472d                	li	a4,11
    800051a6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800051a8:	473d                	li	a4,15
    800051aa:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800051ac:	6705                	lui	a4,0x1
    800051ae:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800051b0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800051b4:	5bdc                	lw	a5,52(a5)
    800051b6:	2781                	sext.w	a5,a5
  if(max == 0)
    800051b8:	c7d9                	beqz	a5,80005246 <virtio_disk_init+0x124>
  if(max < NUM)
    800051ba:	471d                	li	a4,7
    800051bc:	08f77d63          	bgeu	a4,a5,80005256 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800051c0:	100014b7          	lui	s1,0x10001
    800051c4:	47a1                	li	a5,8
    800051c6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800051c8:	6609                	lui	a2,0x2
    800051ca:	4581                	li	a1,0
    800051cc:	00016517          	auipc	a0,0x16
    800051d0:	e3450513          	addi	a0,a0,-460 # 8001b000 <disk>
    800051d4:	ffffb097          	auipc	ra,0xffffb
    800051d8:	fa4080e7          	jalr	-92(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800051dc:	00016717          	auipc	a4,0x16
    800051e0:	e2470713          	addi	a4,a4,-476 # 8001b000 <disk>
    800051e4:	00c75793          	srli	a5,a4,0xc
    800051e8:	2781                	sext.w	a5,a5
    800051ea:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800051ec:	00018797          	auipc	a5,0x18
    800051f0:	e1478793          	addi	a5,a5,-492 # 8001d000 <disk+0x2000>
    800051f4:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800051f6:	00016717          	auipc	a4,0x16
    800051fa:	e8a70713          	addi	a4,a4,-374 # 8001b080 <disk+0x80>
    800051fe:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005200:	00017717          	auipc	a4,0x17
    80005204:	e0070713          	addi	a4,a4,-512 # 8001c000 <disk+0x1000>
    80005208:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000520a:	4705                	li	a4,1
    8000520c:	00e78c23          	sb	a4,24(a5)
    80005210:	00e78ca3          	sb	a4,25(a5)
    80005214:	00e78d23          	sb	a4,26(a5)
    80005218:	00e78da3          	sb	a4,27(a5)
    8000521c:	00e78e23          	sb	a4,28(a5)
    80005220:	00e78ea3          	sb	a4,29(a5)
    80005224:	00e78f23          	sb	a4,30(a5)
    80005228:	00e78fa3          	sb	a4,31(a5)
}
    8000522c:	60e2                	ld	ra,24(sp)
    8000522e:	6442                	ld	s0,16(sp)
    80005230:	64a2                	ld	s1,8(sp)
    80005232:	6105                	addi	sp,sp,32
    80005234:	8082                	ret
    panic("could not find virtio disk");
    80005236:	00003517          	auipc	a0,0x3
    8000523a:	4e250513          	addi	a0,a0,1250 # 80008718 <syscalls+0x350>
    8000523e:	00001097          	auipc	ra,0x1
    80005242:	896080e7          	jalr	-1898(ra) # 80005ad4 <panic>
    panic("virtio disk has no queue 0");
    80005246:	00003517          	auipc	a0,0x3
    8000524a:	4f250513          	addi	a0,a0,1266 # 80008738 <syscalls+0x370>
    8000524e:	00001097          	auipc	ra,0x1
    80005252:	886080e7          	jalr	-1914(ra) # 80005ad4 <panic>
    panic("virtio disk max queue too short");
    80005256:	00003517          	auipc	a0,0x3
    8000525a:	50250513          	addi	a0,a0,1282 # 80008758 <syscalls+0x390>
    8000525e:	00001097          	auipc	ra,0x1
    80005262:	876080e7          	jalr	-1930(ra) # 80005ad4 <panic>

0000000080005266 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005266:	7119                	addi	sp,sp,-128
    80005268:	fc86                	sd	ra,120(sp)
    8000526a:	f8a2                	sd	s0,112(sp)
    8000526c:	f4a6                	sd	s1,104(sp)
    8000526e:	f0ca                	sd	s2,96(sp)
    80005270:	ecce                	sd	s3,88(sp)
    80005272:	e8d2                	sd	s4,80(sp)
    80005274:	e4d6                	sd	s5,72(sp)
    80005276:	e0da                	sd	s6,64(sp)
    80005278:	fc5e                	sd	s7,56(sp)
    8000527a:	f862                	sd	s8,48(sp)
    8000527c:	f466                	sd	s9,40(sp)
    8000527e:	f06a                	sd	s10,32(sp)
    80005280:	ec6e                	sd	s11,24(sp)
    80005282:	0100                	addi	s0,sp,128
    80005284:	8aaa                	mv	s5,a0
    80005286:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005288:	00c52c83          	lw	s9,12(a0)
    8000528c:	001c9c9b          	slliw	s9,s9,0x1
    80005290:	1c82                	slli	s9,s9,0x20
    80005292:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005296:	00018517          	auipc	a0,0x18
    8000529a:	e9250513          	addi	a0,a0,-366 # 8001d128 <disk+0x2128>
    8000529e:	00001097          	auipc	ra,0x1
    800052a2:	d72080e7          	jalr	-654(ra) # 80006010 <acquire>
  for(int i = 0; i < 3; i++){
    800052a6:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800052a8:	44a1                	li	s1,8
      disk.free[i] = 0;
    800052aa:	00016c17          	auipc	s8,0x16
    800052ae:	d56c0c13          	addi	s8,s8,-682 # 8001b000 <disk>
    800052b2:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    800052b4:	4b0d                	li	s6,3
    800052b6:	a0ad                	j	80005320 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    800052b8:	00fc0733          	add	a4,s8,a5
    800052bc:	975e                	add	a4,a4,s7
    800052be:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800052c2:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800052c4:	0207c563          	bltz	a5,800052ee <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800052c8:	2905                	addiw	s2,s2,1
    800052ca:	0611                	addi	a2,a2,4
    800052cc:	19690d63          	beq	s2,s6,80005466 <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    800052d0:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800052d2:	00018717          	auipc	a4,0x18
    800052d6:	d4670713          	addi	a4,a4,-698 # 8001d018 <disk+0x2018>
    800052da:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800052dc:	00074683          	lbu	a3,0(a4)
    800052e0:	fee1                	bnez	a3,800052b8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800052e2:	2785                	addiw	a5,a5,1
    800052e4:	0705                	addi	a4,a4,1
    800052e6:	fe979be3          	bne	a5,s1,800052dc <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800052ea:	57fd                	li	a5,-1
    800052ec:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800052ee:	01205d63          	blez	s2,80005308 <virtio_disk_rw+0xa2>
    800052f2:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800052f4:	000a2503          	lw	a0,0(s4)
    800052f8:	00000097          	auipc	ra,0x0
    800052fc:	d8e080e7          	jalr	-626(ra) # 80005086 <free_desc>
      for(int j = 0; j < i; j++)
    80005300:	2d85                	addiw	s11,s11,1
    80005302:	0a11                	addi	s4,s4,4
    80005304:	ffb918e3          	bne	s2,s11,800052f4 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005308:	00018597          	auipc	a1,0x18
    8000530c:	e2058593          	addi	a1,a1,-480 # 8001d128 <disk+0x2128>
    80005310:	00018517          	auipc	a0,0x18
    80005314:	d0850513          	addi	a0,a0,-760 # 8001d018 <disk+0x2018>
    80005318:	ffffc097          	auipc	ra,0xffffc
    8000531c:	1ea080e7          	jalr	490(ra) # 80001502 <sleep>
  for(int i = 0; i < 3; i++){
    80005320:	f8040a13          	addi	s4,s0,-128
{
    80005324:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005326:	894e                	mv	s2,s3
    80005328:	b765                	j	800052d0 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000532a:	00018697          	auipc	a3,0x18
    8000532e:	cd66b683          	ld	a3,-810(a3) # 8001d000 <disk+0x2000>
    80005332:	96ba                	add	a3,a3,a4
    80005334:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005338:	00016817          	auipc	a6,0x16
    8000533c:	cc880813          	addi	a6,a6,-824 # 8001b000 <disk>
    80005340:	00018697          	auipc	a3,0x18
    80005344:	cc068693          	addi	a3,a3,-832 # 8001d000 <disk+0x2000>
    80005348:	6290                	ld	a2,0(a3)
    8000534a:	963a                	add	a2,a2,a4
    8000534c:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    80005350:	0015e593          	ori	a1,a1,1
    80005354:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80005358:	f8842603          	lw	a2,-120(s0)
    8000535c:	628c                	ld	a1,0(a3)
    8000535e:	972e                	add	a4,a4,a1
    80005360:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005364:	20050593          	addi	a1,a0,512
    80005368:	0592                	slli	a1,a1,0x4
    8000536a:	95c2                	add	a1,a1,a6
    8000536c:	577d                	li	a4,-1
    8000536e:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005372:	00461713          	slli	a4,a2,0x4
    80005376:	6290                	ld	a2,0(a3)
    80005378:	963a                	add	a2,a2,a4
    8000537a:	03078793          	addi	a5,a5,48
    8000537e:	97c2                	add	a5,a5,a6
    80005380:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    80005382:	629c                	ld	a5,0(a3)
    80005384:	97ba                	add	a5,a5,a4
    80005386:	4605                	li	a2,1
    80005388:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000538a:	629c                	ld	a5,0(a3)
    8000538c:	97ba                	add	a5,a5,a4
    8000538e:	4809                	li	a6,2
    80005390:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005394:	629c                	ld	a5,0(a3)
    80005396:	973e                	add	a4,a4,a5
    80005398:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000539c:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800053a0:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800053a4:	6698                	ld	a4,8(a3)
    800053a6:	00275783          	lhu	a5,2(a4)
    800053aa:	8b9d                	andi	a5,a5,7
    800053ac:	0786                	slli	a5,a5,0x1
    800053ae:	97ba                	add	a5,a5,a4
    800053b0:	00a79223          	sh	a0,4(a5)

  __sync_synchronize();
    800053b4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800053b8:	6698                	ld	a4,8(a3)
    800053ba:	00275783          	lhu	a5,2(a4)
    800053be:	2785                	addiw	a5,a5,1
    800053c0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800053c4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800053c8:	100017b7          	lui	a5,0x10001
    800053cc:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800053d0:	004aa783          	lw	a5,4(s5)
    800053d4:	02c79163          	bne	a5,a2,800053f6 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    800053d8:	00018917          	auipc	s2,0x18
    800053dc:	d5090913          	addi	s2,s2,-688 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    800053e0:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800053e2:	85ca                	mv	a1,s2
    800053e4:	8556                	mv	a0,s5
    800053e6:	ffffc097          	auipc	ra,0xffffc
    800053ea:	11c080e7          	jalr	284(ra) # 80001502 <sleep>
  while(b->disk == 1) {
    800053ee:	004aa783          	lw	a5,4(s5)
    800053f2:	fe9788e3          	beq	a5,s1,800053e2 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    800053f6:	f8042903          	lw	s2,-128(s0)
    800053fa:	20090793          	addi	a5,s2,512
    800053fe:	00479713          	slli	a4,a5,0x4
    80005402:	00016797          	auipc	a5,0x16
    80005406:	bfe78793          	addi	a5,a5,-1026 # 8001b000 <disk>
    8000540a:	97ba                	add	a5,a5,a4
    8000540c:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005410:	00018997          	auipc	s3,0x18
    80005414:	bf098993          	addi	s3,s3,-1040 # 8001d000 <disk+0x2000>
    80005418:	00491713          	slli	a4,s2,0x4
    8000541c:	0009b783          	ld	a5,0(s3)
    80005420:	97ba                	add	a5,a5,a4
    80005422:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005426:	854a                	mv	a0,s2
    80005428:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000542c:	00000097          	auipc	ra,0x0
    80005430:	c5a080e7          	jalr	-934(ra) # 80005086 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005434:	8885                	andi	s1,s1,1
    80005436:	f0ed                	bnez	s1,80005418 <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005438:	00018517          	auipc	a0,0x18
    8000543c:	cf050513          	addi	a0,a0,-784 # 8001d128 <disk+0x2128>
    80005440:	00001097          	auipc	ra,0x1
    80005444:	c84080e7          	jalr	-892(ra) # 800060c4 <release>
}
    80005448:	70e6                	ld	ra,120(sp)
    8000544a:	7446                	ld	s0,112(sp)
    8000544c:	74a6                	ld	s1,104(sp)
    8000544e:	7906                	ld	s2,96(sp)
    80005450:	69e6                	ld	s3,88(sp)
    80005452:	6a46                	ld	s4,80(sp)
    80005454:	6aa6                	ld	s5,72(sp)
    80005456:	6b06                	ld	s6,64(sp)
    80005458:	7be2                	ld	s7,56(sp)
    8000545a:	7c42                	ld	s8,48(sp)
    8000545c:	7ca2                	ld	s9,40(sp)
    8000545e:	7d02                	ld	s10,32(sp)
    80005460:	6de2                	ld	s11,24(sp)
    80005462:	6109                	addi	sp,sp,128
    80005464:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005466:	f8042503          	lw	a0,-128(s0)
    8000546a:	20050793          	addi	a5,a0,512
    8000546e:	0792                	slli	a5,a5,0x4
  if(write)
    80005470:	00016817          	auipc	a6,0x16
    80005474:	b9080813          	addi	a6,a6,-1136 # 8001b000 <disk>
    80005478:	00f80733          	add	a4,a6,a5
    8000547c:	01a036b3          	snez	a3,s10
    80005480:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    80005484:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005488:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000548c:	7679                	lui	a2,0xffffe
    8000548e:	963e                	add	a2,a2,a5
    80005490:	00018697          	auipc	a3,0x18
    80005494:	b7068693          	addi	a3,a3,-1168 # 8001d000 <disk+0x2000>
    80005498:	6298                	ld	a4,0(a3)
    8000549a:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000549c:	0a878593          	addi	a1,a5,168
    800054a0:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    800054a2:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800054a4:	6298                	ld	a4,0(a3)
    800054a6:	9732                	add	a4,a4,a2
    800054a8:	45c1                	li	a1,16
    800054aa:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800054ac:	6298                	ld	a4,0(a3)
    800054ae:	9732                	add	a4,a4,a2
    800054b0:	4585                	li	a1,1
    800054b2:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800054b6:	f8442703          	lw	a4,-124(s0)
    800054ba:	628c                	ld	a1,0(a3)
    800054bc:	962e                	add	a2,a2,a1
    800054be:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    800054c2:	0712                	slli	a4,a4,0x4
    800054c4:	6290                	ld	a2,0(a3)
    800054c6:	963a                	add	a2,a2,a4
    800054c8:	058a8593          	addi	a1,s5,88
    800054cc:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800054ce:	6294                	ld	a3,0(a3)
    800054d0:	96ba                	add	a3,a3,a4
    800054d2:	40000613          	li	a2,1024
    800054d6:	c690                	sw	a2,8(a3)
  if(write)
    800054d8:	e40d19e3          	bnez	s10,8000532a <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800054dc:	00018697          	auipc	a3,0x18
    800054e0:	b246b683          	ld	a3,-1244(a3) # 8001d000 <disk+0x2000>
    800054e4:	96ba                	add	a3,a3,a4
    800054e6:	4609                	li	a2,2
    800054e8:	00c69623          	sh	a2,12(a3)
    800054ec:	b5b1                	j	80005338 <virtio_disk_rw+0xd2>

00000000800054ee <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800054ee:	1101                	addi	sp,sp,-32
    800054f0:	ec06                	sd	ra,24(sp)
    800054f2:	e822                	sd	s0,16(sp)
    800054f4:	e426                	sd	s1,8(sp)
    800054f6:	e04a                	sd	s2,0(sp)
    800054f8:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800054fa:	00018517          	auipc	a0,0x18
    800054fe:	c2e50513          	addi	a0,a0,-978 # 8001d128 <disk+0x2128>
    80005502:	00001097          	auipc	ra,0x1
    80005506:	b0e080e7          	jalr	-1266(ra) # 80006010 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000550a:	10001737          	lui	a4,0x10001
    8000550e:	533c                	lw	a5,96(a4)
    80005510:	8b8d                	andi	a5,a5,3
    80005512:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005514:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005518:	00018797          	auipc	a5,0x18
    8000551c:	ae878793          	addi	a5,a5,-1304 # 8001d000 <disk+0x2000>
    80005520:	6b94                	ld	a3,16(a5)
    80005522:	0207d703          	lhu	a4,32(a5)
    80005526:	0026d783          	lhu	a5,2(a3)
    8000552a:	06f70163          	beq	a4,a5,8000558c <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000552e:	00016917          	auipc	s2,0x16
    80005532:	ad290913          	addi	s2,s2,-1326 # 8001b000 <disk>
    80005536:	00018497          	auipc	s1,0x18
    8000553a:	aca48493          	addi	s1,s1,-1334 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    8000553e:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005542:	6898                	ld	a4,16(s1)
    80005544:	0204d783          	lhu	a5,32(s1)
    80005548:	8b9d                	andi	a5,a5,7
    8000554a:	078e                	slli	a5,a5,0x3
    8000554c:	97ba                	add	a5,a5,a4
    8000554e:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005550:	20078713          	addi	a4,a5,512
    80005554:	0712                	slli	a4,a4,0x4
    80005556:	974a                	add	a4,a4,s2
    80005558:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000555c:	e731                	bnez	a4,800055a8 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000555e:	20078793          	addi	a5,a5,512
    80005562:	0792                	slli	a5,a5,0x4
    80005564:	97ca                	add	a5,a5,s2
    80005566:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005568:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000556c:	ffffc097          	auipc	ra,0xffffc
    80005570:	122080e7          	jalr	290(ra) # 8000168e <wakeup>

    disk.used_idx += 1;
    80005574:	0204d783          	lhu	a5,32(s1)
    80005578:	2785                	addiw	a5,a5,1
    8000557a:	17c2                	slli	a5,a5,0x30
    8000557c:	93c1                	srli	a5,a5,0x30
    8000557e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005582:	6898                	ld	a4,16(s1)
    80005584:	00275703          	lhu	a4,2(a4)
    80005588:	faf71be3          	bne	a4,a5,8000553e <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000558c:	00018517          	auipc	a0,0x18
    80005590:	b9c50513          	addi	a0,a0,-1124 # 8001d128 <disk+0x2128>
    80005594:	00001097          	auipc	ra,0x1
    80005598:	b30080e7          	jalr	-1232(ra) # 800060c4 <release>
}
    8000559c:	60e2                	ld	ra,24(sp)
    8000559e:	6442                	ld	s0,16(sp)
    800055a0:	64a2                	ld	s1,8(sp)
    800055a2:	6902                	ld	s2,0(sp)
    800055a4:	6105                	addi	sp,sp,32
    800055a6:	8082                	ret
      panic("virtio_disk_intr status");
    800055a8:	00003517          	auipc	a0,0x3
    800055ac:	1d050513          	addi	a0,a0,464 # 80008778 <syscalls+0x3b0>
    800055b0:	00000097          	auipc	ra,0x0
    800055b4:	524080e7          	jalr	1316(ra) # 80005ad4 <panic>

00000000800055b8 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800055b8:	1141                	addi	sp,sp,-16
    800055ba:	e422                	sd	s0,8(sp)
    800055bc:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800055be:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800055c2:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800055c6:	0037979b          	slliw	a5,a5,0x3
    800055ca:	02004737          	lui	a4,0x2004
    800055ce:	97ba                	add	a5,a5,a4
    800055d0:	0200c737          	lui	a4,0x200c
    800055d4:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800055d8:	000f4637          	lui	a2,0xf4
    800055dc:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800055e0:	95b2                	add	a1,a1,a2
    800055e2:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800055e4:	00269713          	slli	a4,a3,0x2
    800055e8:	9736                	add	a4,a4,a3
    800055ea:	00371693          	slli	a3,a4,0x3
    800055ee:	00019717          	auipc	a4,0x19
    800055f2:	a1270713          	addi	a4,a4,-1518 # 8001e000 <timer_scratch>
    800055f6:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800055f8:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800055fa:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800055fc:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005600:	00000797          	auipc	a5,0x0
    80005604:	9c078793          	addi	a5,a5,-1600 # 80004fc0 <timervec>
    80005608:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000560c:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005610:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005614:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005618:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000561c:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005620:	30479073          	csrw	mie,a5
}
    80005624:	6422                	ld	s0,8(sp)
    80005626:	0141                	addi	sp,sp,16
    80005628:	8082                	ret

000000008000562a <start>:
{
    8000562a:	1141                	addi	sp,sp,-16
    8000562c:	e406                	sd	ra,8(sp)
    8000562e:	e022                	sd	s0,0(sp)
    80005630:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005632:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005636:	7779                	lui	a4,0xffffe
    80005638:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    8000563c:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000563e:	6705                	lui	a4,0x1
    80005640:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005644:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005646:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000564a:	ffffb797          	auipc	a5,0xffffb
    8000564e:	cd478793          	addi	a5,a5,-812 # 8000031e <main>
    80005652:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005656:	4781                	li	a5,0
    80005658:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000565c:	67c1                	lui	a5,0x10
    8000565e:	17fd                	addi	a5,a5,-1
    80005660:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005664:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005668:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000566c:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005670:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005674:	57fd                	li	a5,-1
    80005676:	83a9                	srli	a5,a5,0xa
    80005678:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000567c:	47bd                	li	a5,15
    8000567e:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005682:	00000097          	auipc	ra,0x0
    80005686:	f36080e7          	jalr	-202(ra) # 800055b8 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000568a:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000568e:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005690:	823e                	mv	tp,a5
  asm volatile("mret");
    80005692:	30200073          	mret
}
    80005696:	60a2                	ld	ra,8(sp)
    80005698:	6402                	ld	s0,0(sp)
    8000569a:	0141                	addi	sp,sp,16
    8000569c:	8082                	ret

000000008000569e <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000569e:	715d                	addi	sp,sp,-80
    800056a0:	e486                	sd	ra,72(sp)
    800056a2:	e0a2                	sd	s0,64(sp)
    800056a4:	fc26                	sd	s1,56(sp)
    800056a6:	f84a                	sd	s2,48(sp)
    800056a8:	f44e                	sd	s3,40(sp)
    800056aa:	f052                	sd	s4,32(sp)
    800056ac:	ec56                	sd	s5,24(sp)
    800056ae:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800056b0:	04c05663          	blez	a2,800056fc <consolewrite+0x5e>
    800056b4:	8a2a                	mv	s4,a0
    800056b6:	84ae                	mv	s1,a1
    800056b8:	89b2                	mv	s3,a2
    800056ba:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800056bc:	5afd                	li	s5,-1
    800056be:	4685                	li	a3,1
    800056c0:	8626                	mv	a2,s1
    800056c2:	85d2                	mv	a1,s4
    800056c4:	fbf40513          	addi	a0,s0,-65
    800056c8:	ffffc097          	auipc	ra,0xffffc
    800056cc:	234080e7          	jalr	564(ra) # 800018fc <either_copyin>
    800056d0:	01550c63          	beq	a0,s5,800056e8 <consolewrite+0x4a>
      break;
    uartputc(c);
    800056d4:	fbf44503          	lbu	a0,-65(s0)
    800056d8:	00000097          	auipc	ra,0x0
    800056dc:	77a080e7          	jalr	1914(ra) # 80005e52 <uartputc>
  for(i = 0; i < n; i++){
    800056e0:	2905                	addiw	s2,s2,1
    800056e2:	0485                	addi	s1,s1,1
    800056e4:	fd299de3          	bne	s3,s2,800056be <consolewrite+0x20>
  }

  return i;
}
    800056e8:	854a                	mv	a0,s2
    800056ea:	60a6                	ld	ra,72(sp)
    800056ec:	6406                	ld	s0,64(sp)
    800056ee:	74e2                	ld	s1,56(sp)
    800056f0:	7942                	ld	s2,48(sp)
    800056f2:	79a2                	ld	s3,40(sp)
    800056f4:	7a02                	ld	s4,32(sp)
    800056f6:	6ae2                	ld	s5,24(sp)
    800056f8:	6161                	addi	sp,sp,80
    800056fa:	8082                	ret
  for(i = 0; i < n; i++){
    800056fc:	4901                	li	s2,0
    800056fe:	b7ed                	j	800056e8 <consolewrite+0x4a>

0000000080005700 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005700:	7159                	addi	sp,sp,-112
    80005702:	f486                	sd	ra,104(sp)
    80005704:	f0a2                	sd	s0,96(sp)
    80005706:	eca6                	sd	s1,88(sp)
    80005708:	e8ca                	sd	s2,80(sp)
    8000570a:	e4ce                	sd	s3,72(sp)
    8000570c:	e0d2                	sd	s4,64(sp)
    8000570e:	fc56                	sd	s5,56(sp)
    80005710:	f85a                	sd	s6,48(sp)
    80005712:	f45e                	sd	s7,40(sp)
    80005714:	f062                	sd	s8,32(sp)
    80005716:	ec66                	sd	s9,24(sp)
    80005718:	e86a                	sd	s10,16(sp)
    8000571a:	1880                	addi	s0,sp,112
    8000571c:	8aaa                	mv	s5,a0
    8000571e:	8a2e                	mv	s4,a1
    80005720:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005722:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005726:	00021517          	auipc	a0,0x21
    8000572a:	a1a50513          	addi	a0,a0,-1510 # 80026140 <cons>
    8000572e:	00001097          	auipc	ra,0x1
    80005732:	8e2080e7          	jalr	-1822(ra) # 80006010 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005736:	00021497          	auipc	s1,0x21
    8000573a:	a0a48493          	addi	s1,s1,-1526 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000573e:	00021917          	auipc	s2,0x21
    80005742:	a9a90913          	addi	s2,s2,-1382 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005746:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005748:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000574a:	4ca9                	li	s9,10
  while(n > 0){
    8000574c:	07305863          	blez	s3,800057bc <consoleread+0xbc>
    while(cons.r == cons.w){
    80005750:	0984a783          	lw	a5,152(s1)
    80005754:	09c4a703          	lw	a4,156(s1)
    80005758:	02f71463          	bne	a4,a5,80005780 <consoleread+0x80>
      if(myproc()->killed){
    8000575c:	ffffb097          	auipc	ra,0xffffb
    80005760:	6e6080e7          	jalr	1766(ra) # 80000e42 <myproc>
    80005764:	551c                	lw	a5,40(a0)
    80005766:	e7b5                	bnez	a5,800057d2 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    80005768:	85a6                	mv	a1,s1
    8000576a:	854a                	mv	a0,s2
    8000576c:	ffffc097          	auipc	ra,0xffffc
    80005770:	d96080e7          	jalr	-618(ra) # 80001502 <sleep>
    while(cons.r == cons.w){
    80005774:	0984a783          	lw	a5,152(s1)
    80005778:	09c4a703          	lw	a4,156(s1)
    8000577c:	fef700e3          	beq	a4,a5,8000575c <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005780:	0017871b          	addiw	a4,a5,1
    80005784:	08e4ac23          	sw	a4,152(s1)
    80005788:	07f7f713          	andi	a4,a5,127
    8000578c:	9726                	add	a4,a4,s1
    8000578e:	01874703          	lbu	a4,24(a4)
    80005792:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005796:	077d0563          	beq	s10,s7,80005800 <consoleread+0x100>
    cbuf = c;
    8000579a:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000579e:	4685                	li	a3,1
    800057a0:	f9f40613          	addi	a2,s0,-97
    800057a4:	85d2                	mv	a1,s4
    800057a6:	8556                	mv	a0,s5
    800057a8:	ffffc097          	auipc	ra,0xffffc
    800057ac:	0fe080e7          	jalr	254(ra) # 800018a6 <either_copyout>
    800057b0:	01850663          	beq	a0,s8,800057bc <consoleread+0xbc>
    dst++;
    800057b4:	0a05                	addi	s4,s4,1
    --n;
    800057b6:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    800057b8:	f99d1ae3          	bne	s10,s9,8000574c <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800057bc:	00021517          	auipc	a0,0x21
    800057c0:	98450513          	addi	a0,a0,-1660 # 80026140 <cons>
    800057c4:	00001097          	auipc	ra,0x1
    800057c8:	900080e7          	jalr	-1792(ra) # 800060c4 <release>

  return target - n;
    800057cc:	413b053b          	subw	a0,s6,s3
    800057d0:	a811                	j	800057e4 <consoleread+0xe4>
        release(&cons.lock);
    800057d2:	00021517          	auipc	a0,0x21
    800057d6:	96e50513          	addi	a0,a0,-1682 # 80026140 <cons>
    800057da:	00001097          	auipc	ra,0x1
    800057de:	8ea080e7          	jalr	-1814(ra) # 800060c4 <release>
        return -1;
    800057e2:	557d                	li	a0,-1
}
    800057e4:	70a6                	ld	ra,104(sp)
    800057e6:	7406                	ld	s0,96(sp)
    800057e8:	64e6                	ld	s1,88(sp)
    800057ea:	6946                	ld	s2,80(sp)
    800057ec:	69a6                	ld	s3,72(sp)
    800057ee:	6a06                	ld	s4,64(sp)
    800057f0:	7ae2                	ld	s5,56(sp)
    800057f2:	7b42                	ld	s6,48(sp)
    800057f4:	7ba2                	ld	s7,40(sp)
    800057f6:	7c02                	ld	s8,32(sp)
    800057f8:	6ce2                	ld	s9,24(sp)
    800057fa:	6d42                	ld	s10,16(sp)
    800057fc:	6165                	addi	sp,sp,112
    800057fe:	8082                	ret
      if(n < target){
    80005800:	0009871b          	sext.w	a4,s3
    80005804:	fb677ce3          	bgeu	a4,s6,800057bc <consoleread+0xbc>
        cons.r--;
    80005808:	00021717          	auipc	a4,0x21
    8000580c:	9cf72823          	sw	a5,-1584(a4) # 800261d8 <cons+0x98>
    80005810:	b775                	j	800057bc <consoleread+0xbc>

0000000080005812 <consputc>:
{
    80005812:	1141                	addi	sp,sp,-16
    80005814:	e406                	sd	ra,8(sp)
    80005816:	e022                	sd	s0,0(sp)
    80005818:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000581a:	10000793          	li	a5,256
    8000581e:	00f50a63          	beq	a0,a5,80005832 <consputc+0x20>
    uartputc_sync(c);
    80005822:	00000097          	auipc	ra,0x0
    80005826:	55e080e7          	jalr	1374(ra) # 80005d80 <uartputc_sync>
}
    8000582a:	60a2                	ld	ra,8(sp)
    8000582c:	6402                	ld	s0,0(sp)
    8000582e:	0141                	addi	sp,sp,16
    80005830:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005832:	4521                	li	a0,8
    80005834:	00000097          	auipc	ra,0x0
    80005838:	54c080e7          	jalr	1356(ra) # 80005d80 <uartputc_sync>
    8000583c:	02000513          	li	a0,32
    80005840:	00000097          	auipc	ra,0x0
    80005844:	540080e7          	jalr	1344(ra) # 80005d80 <uartputc_sync>
    80005848:	4521                	li	a0,8
    8000584a:	00000097          	auipc	ra,0x0
    8000584e:	536080e7          	jalr	1334(ra) # 80005d80 <uartputc_sync>
    80005852:	bfe1                	j	8000582a <consputc+0x18>

0000000080005854 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005854:	1101                	addi	sp,sp,-32
    80005856:	ec06                	sd	ra,24(sp)
    80005858:	e822                	sd	s0,16(sp)
    8000585a:	e426                	sd	s1,8(sp)
    8000585c:	e04a                	sd	s2,0(sp)
    8000585e:	1000                	addi	s0,sp,32
    80005860:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005862:	00021517          	auipc	a0,0x21
    80005866:	8de50513          	addi	a0,a0,-1826 # 80026140 <cons>
    8000586a:	00000097          	auipc	ra,0x0
    8000586e:	7a6080e7          	jalr	1958(ra) # 80006010 <acquire>

  switch(c){
    80005872:	47d5                	li	a5,21
    80005874:	0af48663          	beq	s1,a5,80005920 <consoleintr+0xcc>
    80005878:	0297ca63          	blt	a5,s1,800058ac <consoleintr+0x58>
    8000587c:	47a1                	li	a5,8
    8000587e:	0ef48763          	beq	s1,a5,8000596c <consoleintr+0x118>
    80005882:	47c1                	li	a5,16
    80005884:	10f49a63          	bne	s1,a5,80005998 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005888:	ffffc097          	auipc	ra,0xffffc
    8000588c:	0ca080e7          	jalr	202(ra) # 80001952 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005890:	00021517          	auipc	a0,0x21
    80005894:	8b050513          	addi	a0,a0,-1872 # 80026140 <cons>
    80005898:	00001097          	auipc	ra,0x1
    8000589c:	82c080e7          	jalr	-2004(ra) # 800060c4 <release>
}
    800058a0:	60e2                	ld	ra,24(sp)
    800058a2:	6442                	ld	s0,16(sp)
    800058a4:	64a2                	ld	s1,8(sp)
    800058a6:	6902                	ld	s2,0(sp)
    800058a8:	6105                	addi	sp,sp,32
    800058aa:	8082                	ret
  switch(c){
    800058ac:	07f00793          	li	a5,127
    800058b0:	0af48e63          	beq	s1,a5,8000596c <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800058b4:	00021717          	auipc	a4,0x21
    800058b8:	88c70713          	addi	a4,a4,-1908 # 80026140 <cons>
    800058bc:	0a072783          	lw	a5,160(a4)
    800058c0:	09872703          	lw	a4,152(a4)
    800058c4:	9f99                	subw	a5,a5,a4
    800058c6:	07f00713          	li	a4,127
    800058ca:	fcf763e3          	bltu	a4,a5,80005890 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    800058ce:	47b5                	li	a5,13
    800058d0:	0cf48763          	beq	s1,a5,8000599e <consoleintr+0x14a>
      consputc(c);
    800058d4:	8526                	mv	a0,s1
    800058d6:	00000097          	auipc	ra,0x0
    800058da:	f3c080e7          	jalr	-196(ra) # 80005812 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800058de:	00021797          	auipc	a5,0x21
    800058e2:	86278793          	addi	a5,a5,-1950 # 80026140 <cons>
    800058e6:	0a07a703          	lw	a4,160(a5)
    800058ea:	0017069b          	addiw	a3,a4,1
    800058ee:	0006861b          	sext.w	a2,a3
    800058f2:	0ad7a023          	sw	a3,160(a5)
    800058f6:	07f77713          	andi	a4,a4,127
    800058fa:	97ba                	add	a5,a5,a4
    800058fc:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005900:	47a9                	li	a5,10
    80005902:	0cf48563          	beq	s1,a5,800059cc <consoleintr+0x178>
    80005906:	4791                	li	a5,4
    80005908:	0cf48263          	beq	s1,a5,800059cc <consoleintr+0x178>
    8000590c:	00021797          	auipc	a5,0x21
    80005910:	8cc7a783          	lw	a5,-1844(a5) # 800261d8 <cons+0x98>
    80005914:	0807879b          	addiw	a5,a5,128
    80005918:	f6f61ce3          	bne	a2,a5,80005890 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000591c:	863e                	mv	a2,a5
    8000591e:	a07d                	j	800059cc <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005920:	00021717          	auipc	a4,0x21
    80005924:	82070713          	addi	a4,a4,-2016 # 80026140 <cons>
    80005928:	0a072783          	lw	a5,160(a4)
    8000592c:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005930:	00021497          	auipc	s1,0x21
    80005934:	81048493          	addi	s1,s1,-2032 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005938:	4929                	li	s2,10
    8000593a:	f4f70be3          	beq	a4,a5,80005890 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    8000593e:	37fd                	addiw	a5,a5,-1
    80005940:	07f7f713          	andi	a4,a5,127
    80005944:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005946:	01874703          	lbu	a4,24(a4)
    8000594a:	f52703e3          	beq	a4,s2,80005890 <consoleintr+0x3c>
      cons.e--;
    8000594e:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005952:	10000513          	li	a0,256
    80005956:	00000097          	auipc	ra,0x0
    8000595a:	ebc080e7          	jalr	-324(ra) # 80005812 <consputc>
    while(cons.e != cons.w &&
    8000595e:	0a04a783          	lw	a5,160(s1)
    80005962:	09c4a703          	lw	a4,156(s1)
    80005966:	fcf71ce3          	bne	a4,a5,8000593e <consoleintr+0xea>
    8000596a:	b71d                	j	80005890 <consoleintr+0x3c>
    if(cons.e != cons.w){
    8000596c:	00020717          	auipc	a4,0x20
    80005970:	7d470713          	addi	a4,a4,2004 # 80026140 <cons>
    80005974:	0a072783          	lw	a5,160(a4)
    80005978:	09c72703          	lw	a4,156(a4)
    8000597c:	f0f70ae3          	beq	a4,a5,80005890 <consoleintr+0x3c>
      cons.e--;
    80005980:	37fd                	addiw	a5,a5,-1
    80005982:	00021717          	auipc	a4,0x21
    80005986:	84f72f23          	sw	a5,-1954(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    8000598a:	10000513          	li	a0,256
    8000598e:	00000097          	auipc	ra,0x0
    80005992:	e84080e7          	jalr	-380(ra) # 80005812 <consputc>
    80005996:	bded                	j	80005890 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005998:	ee048ce3          	beqz	s1,80005890 <consoleintr+0x3c>
    8000599c:	bf21                	j	800058b4 <consoleintr+0x60>
      consputc(c);
    8000599e:	4529                	li	a0,10
    800059a0:	00000097          	auipc	ra,0x0
    800059a4:	e72080e7          	jalr	-398(ra) # 80005812 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800059a8:	00020797          	auipc	a5,0x20
    800059ac:	79878793          	addi	a5,a5,1944 # 80026140 <cons>
    800059b0:	0a07a703          	lw	a4,160(a5)
    800059b4:	0017069b          	addiw	a3,a4,1
    800059b8:	0006861b          	sext.w	a2,a3
    800059bc:	0ad7a023          	sw	a3,160(a5)
    800059c0:	07f77713          	andi	a4,a4,127
    800059c4:	97ba                	add	a5,a5,a4
    800059c6:	4729                	li	a4,10
    800059c8:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800059cc:	00021797          	auipc	a5,0x21
    800059d0:	80c7a823          	sw	a2,-2032(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    800059d4:	00021517          	auipc	a0,0x21
    800059d8:	80450513          	addi	a0,a0,-2044 # 800261d8 <cons+0x98>
    800059dc:	ffffc097          	auipc	ra,0xffffc
    800059e0:	cb2080e7          	jalr	-846(ra) # 8000168e <wakeup>
    800059e4:	b575                	j	80005890 <consoleintr+0x3c>

00000000800059e6 <consoleinit>:

void
consoleinit(void)
{
    800059e6:	1141                	addi	sp,sp,-16
    800059e8:	e406                	sd	ra,8(sp)
    800059ea:	e022                	sd	s0,0(sp)
    800059ec:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800059ee:	00003597          	auipc	a1,0x3
    800059f2:	da258593          	addi	a1,a1,-606 # 80008790 <syscalls+0x3c8>
    800059f6:	00020517          	auipc	a0,0x20
    800059fa:	74a50513          	addi	a0,a0,1866 # 80026140 <cons>
    800059fe:	00000097          	auipc	ra,0x0
    80005a02:	582080e7          	jalr	1410(ra) # 80005f80 <initlock>

  uartinit();
    80005a06:	00000097          	auipc	ra,0x0
    80005a0a:	32a080e7          	jalr	810(ra) # 80005d30 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005a0e:	00013797          	auipc	a5,0x13
    80005a12:	6ba78793          	addi	a5,a5,1722 # 800190c8 <devsw>
    80005a16:	00000717          	auipc	a4,0x0
    80005a1a:	cea70713          	addi	a4,a4,-790 # 80005700 <consoleread>
    80005a1e:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005a20:	00000717          	auipc	a4,0x0
    80005a24:	c7e70713          	addi	a4,a4,-898 # 8000569e <consolewrite>
    80005a28:	ef98                	sd	a4,24(a5)
}
    80005a2a:	60a2                	ld	ra,8(sp)
    80005a2c:	6402                	ld	s0,0(sp)
    80005a2e:	0141                	addi	sp,sp,16
    80005a30:	8082                	ret

0000000080005a32 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005a32:	7179                	addi	sp,sp,-48
    80005a34:	f406                	sd	ra,40(sp)
    80005a36:	f022                	sd	s0,32(sp)
    80005a38:	ec26                	sd	s1,24(sp)
    80005a3a:	e84a                	sd	s2,16(sp)
    80005a3c:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005a3e:	c219                	beqz	a2,80005a44 <printint+0x12>
    80005a40:	08054663          	bltz	a0,80005acc <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005a44:	2501                	sext.w	a0,a0
    80005a46:	4881                	li	a7,0
    80005a48:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005a4c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005a4e:	2581                	sext.w	a1,a1
    80005a50:	00003617          	auipc	a2,0x3
    80005a54:	d7060613          	addi	a2,a2,-656 # 800087c0 <digits>
    80005a58:	883a                	mv	a6,a4
    80005a5a:	2705                	addiw	a4,a4,1
    80005a5c:	02b577bb          	remuw	a5,a0,a1
    80005a60:	1782                	slli	a5,a5,0x20
    80005a62:	9381                	srli	a5,a5,0x20
    80005a64:	97b2                	add	a5,a5,a2
    80005a66:	0007c783          	lbu	a5,0(a5)
    80005a6a:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005a6e:	0005079b          	sext.w	a5,a0
    80005a72:	02b5553b          	divuw	a0,a0,a1
    80005a76:	0685                	addi	a3,a3,1
    80005a78:	feb7f0e3          	bgeu	a5,a1,80005a58 <printint+0x26>

  if(sign)
    80005a7c:	00088b63          	beqz	a7,80005a92 <printint+0x60>
    buf[i++] = '-';
    80005a80:	fe040793          	addi	a5,s0,-32
    80005a84:	973e                	add	a4,a4,a5
    80005a86:	02d00793          	li	a5,45
    80005a8a:	fef70823          	sb	a5,-16(a4)
    80005a8e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005a92:	02e05763          	blez	a4,80005ac0 <printint+0x8e>
    80005a96:	fd040793          	addi	a5,s0,-48
    80005a9a:	00e784b3          	add	s1,a5,a4
    80005a9e:	fff78913          	addi	s2,a5,-1
    80005aa2:	993a                	add	s2,s2,a4
    80005aa4:	377d                	addiw	a4,a4,-1
    80005aa6:	1702                	slli	a4,a4,0x20
    80005aa8:	9301                	srli	a4,a4,0x20
    80005aaa:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005aae:	fff4c503          	lbu	a0,-1(s1)
    80005ab2:	00000097          	auipc	ra,0x0
    80005ab6:	d60080e7          	jalr	-672(ra) # 80005812 <consputc>
  while(--i >= 0)
    80005aba:	14fd                	addi	s1,s1,-1
    80005abc:	ff2499e3          	bne	s1,s2,80005aae <printint+0x7c>
}
    80005ac0:	70a2                	ld	ra,40(sp)
    80005ac2:	7402                	ld	s0,32(sp)
    80005ac4:	64e2                	ld	s1,24(sp)
    80005ac6:	6942                	ld	s2,16(sp)
    80005ac8:	6145                	addi	sp,sp,48
    80005aca:	8082                	ret
    x = -xx;
    80005acc:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005ad0:	4885                	li	a7,1
    x = -xx;
    80005ad2:	bf9d                	j	80005a48 <printint+0x16>

0000000080005ad4 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005ad4:	1101                	addi	sp,sp,-32
    80005ad6:	ec06                	sd	ra,24(sp)
    80005ad8:	e822                	sd	s0,16(sp)
    80005ada:	e426                	sd	s1,8(sp)
    80005adc:	1000                	addi	s0,sp,32
    80005ade:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005ae0:	00020797          	auipc	a5,0x20
    80005ae4:	7207a023          	sw	zero,1824(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005ae8:	00003517          	auipc	a0,0x3
    80005aec:	cb050513          	addi	a0,a0,-848 # 80008798 <syscalls+0x3d0>
    80005af0:	00000097          	auipc	ra,0x0
    80005af4:	02e080e7          	jalr	46(ra) # 80005b1e <printf>
  printf(s);
    80005af8:	8526                	mv	a0,s1
    80005afa:	00000097          	auipc	ra,0x0
    80005afe:	024080e7          	jalr	36(ra) # 80005b1e <printf>
  printf("\n");
    80005b02:	00002517          	auipc	a0,0x2
    80005b06:	54650513          	addi	a0,a0,1350 # 80008048 <etext+0x48>
    80005b0a:	00000097          	auipc	ra,0x0
    80005b0e:	014080e7          	jalr	20(ra) # 80005b1e <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005b12:	4785                	li	a5,1
    80005b14:	00003717          	auipc	a4,0x3
    80005b18:	50f72423          	sw	a5,1288(a4) # 8000901c <panicked>
  for(;;)
    80005b1c:	a001                	j	80005b1c <panic+0x48>

0000000080005b1e <printf>:
{
    80005b1e:	7131                	addi	sp,sp,-192
    80005b20:	fc86                	sd	ra,120(sp)
    80005b22:	f8a2                	sd	s0,112(sp)
    80005b24:	f4a6                	sd	s1,104(sp)
    80005b26:	f0ca                	sd	s2,96(sp)
    80005b28:	ecce                	sd	s3,88(sp)
    80005b2a:	e8d2                	sd	s4,80(sp)
    80005b2c:	e4d6                	sd	s5,72(sp)
    80005b2e:	e0da                	sd	s6,64(sp)
    80005b30:	fc5e                	sd	s7,56(sp)
    80005b32:	f862                	sd	s8,48(sp)
    80005b34:	f466                	sd	s9,40(sp)
    80005b36:	f06a                	sd	s10,32(sp)
    80005b38:	ec6e                	sd	s11,24(sp)
    80005b3a:	0100                	addi	s0,sp,128
    80005b3c:	8a2a                	mv	s4,a0
    80005b3e:	e40c                	sd	a1,8(s0)
    80005b40:	e810                	sd	a2,16(s0)
    80005b42:	ec14                	sd	a3,24(s0)
    80005b44:	f018                	sd	a4,32(s0)
    80005b46:	f41c                	sd	a5,40(s0)
    80005b48:	03043823          	sd	a6,48(s0)
    80005b4c:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005b50:	00020d97          	auipc	s11,0x20
    80005b54:	6b0dad83          	lw	s11,1712(s11) # 80026200 <pr+0x18>
  if(locking)
    80005b58:	020d9b63          	bnez	s11,80005b8e <printf+0x70>
  if (fmt == 0)
    80005b5c:	040a0263          	beqz	s4,80005ba0 <printf+0x82>
  va_start(ap, fmt);
    80005b60:	00840793          	addi	a5,s0,8
    80005b64:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005b68:	000a4503          	lbu	a0,0(s4)
    80005b6c:	14050f63          	beqz	a0,80005cca <printf+0x1ac>
    80005b70:	4981                	li	s3,0
    if(c != '%'){
    80005b72:	02500a93          	li	s5,37
    switch(c){
    80005b76:	07000b93          	li	s7,112
  consputc('x');
    80005b7a:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005b7c:	00003b17          	auipc	s6,0x3
    80005b80:	c44b0b13          	addi	s6,s6,-956 # 800087c0 <digits>
    switch(c){
    80005b84:	07300c93          	li	s9,115
    80005b88:	06400c13          	li	s8,100
    80005b8c:	a82d                	j	80005bc6 <printf+0xa8>
    acquire(&pr.lock);
    80005b8e:	00020517          	auipc	a0,0x20
    80005b92:	65a50513          	addi	a0,a0,1626 # 800261e8 <pr>
    80005b96:	00000097          	auipc	ra,0x0
    80005b9a:	47a080e7          	jalr	1146(ra) # 80006010 <acquire>
    80005b9e:	bf7d                	j	80005b5c <printf+0x3e>
    panic("null fmt");
    80005ba0:	00003517          	auipc	a0,0x3
    80005ba4:	c0850513          	addi	a0,a0,-1016 # 800087a8 <syscalls+0x3e0>
    80005ba8:	00000097          	auipc	ra,0x0
    80005bac:	f2c080e7          	jalr	-212(ra) # 80005ad4 <panic>
      consputc(c);
    80005bb0:	00000097          	auipc	ra,0x0
    80005bb4:	c62080e7          	jalr	-926(ra) # 80005812 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005bb8:	2985                	addiw	s3,s3,1
    80005bba:	013a07b3          	add	a5,s4,s3
    80005bbe:	0007c503          	lbu	a0,0(a5)
    80005bc2:	10050463          	beqz	a0,80005cca <printf+0x1ac>
    if(c != '%'){
    80005bc6:	ff5515e3          	bne	a0,s5,80005bb0 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005bca:	2985                	addiw	s3,s3,1
    80005bcc:	013a07b3          	add	a5,s4,s3
    80005bd0:	0007c783          	lbu	a5,0(a5)
    80005bd4:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005bd8:	cbed                	beqz	a5,80005cca <printf+0x1ac>
    switch(c){
    80005bda:	05778a63          	beq	a5,s7,80005c2e <printf+0x110>
    80005bde:	02fbf663          	bgeu	s7,a5,80005c0a <printf+0xec>
    80005be2:	09978863          	beq	a5,s9,80005c72 <printf+0x154>
    80005be6:	07800713          	li	a4,120
    80005bea:	0ce79563          	bne	a5,a4,80005cb4 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005bee:	f8843783          	ld	a5,-120(s0)
    80005bf2:	00878713          	addi	a4,a5,8
    80005bf6:	f8e43423          	sd	a4,-120(s0)
    80005bfa:	4605                	li	a2,1
    80005bfc:	85ea                	mv	a1,s10
    80005bfe:	4388                	lw	a0,0(a5)
    80005c00:	00000097          	auipc	ra,0x0
    80005c04:	e32080e7          	jalr	-462(ra) # 80005a32 <printint>
      break;
    80005c08:	bf45                	j	80005bb8 <printf+0x9a>
    switch(c){
    80005c0a:	09578f63          	beq	a5,s5,80005ca8 <printf+0x18a>
    80005c0e:	0b879363          	bne	a5,s8,80005cb4 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005c12:	f8843783          	ld	a5,-120(s0)
    80005c16:	00878713          	addi	a4,a5,8
    80005c1a:	f8e43423          	sd	a4,-120(s0)
    80005c1e:	4605                	li	a2,1
    80005c20:	45a9                	li	a1,10
    80005c22:	4388                	lw	a0,0(a5)
    80005c24:	00000097          	auipc	ra,0x0
    80005c28:	e0e080e7          	jalr	-498(ra) # 80005a32 <printint>
      break;
    80005c2c:	b771                	j	80005bb8 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005c2e:	f8843783          	ld	a5,-120(s0)
    80005c32:	00878713          	addi	a4,a5,8
    80005c36:	f8e43423          	sd	a4,-120(s0)
    80005c3a:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005c3e:	03000513          	li	a0,48
    80005c42:	00000097          	auipc	ra,0x0
    80005c46:	bd0080e7          	jalr	-1072(ra) # 80005812 <consputc>
  consputc('x');
    80005c4a:	07800513          	li	a0,120
    80005c4e:	00000097          	auipc	ra,0x0
    80005c52:	bc4080e7          	jalr	-1084(ra) # 80005812 <consputc>
    80005c56:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005c58:	03c95793          	srli	a5,s2,0x3c
    80005c5c:	97da                	add	a5,a5,s6
    80005c5e:	0007c503          	lbu	a0,0(a5)
    80005c62:	00000097          	auipc	ra,0x0
    80005c66:	bb0080e7          	jalr	-1104(ra) # 80005812 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005c6a:	0912                	slli	s2,s2,0x4
    80005c6c:	34fd                	addiw	s1,s1,-1
    80005c6e:	f4ed                	bnez	s1,80005c58 <printf+0x13a>
    80005c70:	b7a1                	j	80005bb8 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005c72:	f8843783          	ld	a5,-120(s0)
    80005c76:	00878713          	addi	a4,a5,8
    80005c7a:	f8e43423          	sd	a4,-120(s0)
    80005c7e:	6384                	ld	s1,0(a5)
    80005c80:	cc89                	beqz	s1,80005c9a <printf+0x17c>
      for(; *s; s++)
    80005c82:	0004c503          	lbu	a0,0(s1)
    80005c86:	d90d                	beqz	a0,80005bb8 <printf+0x9a>
        consputc(*s);
    80005c88:	00000097          	auipc	ra,0x0
    80005c8c:	b8a080e7          	jalr	-1142(ra) # 80005812 <consputc>
      for(; *s; s++)
    80005c90:	0485                	addi	s1,s1,1
    80005c92:	0004c503          	lbu	a0,0(s1)
    80005c96:	f96d                	bnez	a0,80005c88 <printf+0x16a>
    80005c98:	b705                	j	80005bb8 <printf+0x9a>
        s = "(null)";
    80005c9a:	00003497          	auipc	s1,0x3
    80005c9e:	b0648493          	addi	s1,s1,-1274 # 800087a0 <syscalls+0x3d8>
      for(; *s; s++)
    80005ca2:	02800513          	li	a0,40
    80005ca6:	b7cd                	j	80005c88 <printf+0x16a>
      consputc('%');
    80005ca8:	8556                	mv	a0,s5
    80005caa:	00000097          	auipc	ra,0x0
    80005cae:	b68080e7          	jalr	-1176(ra) # 80005812 <consputc>
      break;
    80005cb2:	b719                	j	80005bb8 <printf+0x9a>
      consputc('%');
    80005cb4:	8556                	mv	a0,s5
    80005cb6:	00000097          	auipc	ra,0x0
    80005cba:	b5c080e7          	jalr	-1188(ra) # 80005812 <consputc>
      consputc(c);
    80005cbe:	8526                	mv	a0,s1
    80005cc0:	00000097          	auipc	ra,0x0
    80005cc4:	b52080e7          	jalr	-1198(ra) # 80005812 <consputc>
      break;
    80005cc8:	bdc5                	j	80005bb8 <printf+0x9a>
  if(locking)
    80005cca:	020d9163          	bnez	s11,80005cec <printf+0x1ce>
}
    80005cce:	70e6                	ld	ra,120(sp)
    80005cd0:	7446                	ld	s0,112(sp)
    80005cd2:	74a6                	ld	s1,104(sp)
    80005cd4:	7906                	ld	s2,96(sp)
    80005cd6:	69e6                	ld	s3,88(sp)
    80005cd8:	6a46                	ld	s4,80(sp)
    80005cda:	6aa6                	ld	s5,72(sp)
    80005cdc:	6b06                	ld	s6,64(sp)
    80005cde:	7be2                	ld	s7,56(sp)
    80005ce0:	7c42                	ld	s8,48(sp)
    80005ce2:	7ca2                	ld	s9,40(sp)
    80005ce4:	7d02                	ld	s10,32(sp)
    80005ce6:	6de2                	ld	s11,24(sp)
    80005ce8:	6129                	addi	sp,sp,192
    80005cea:	8082                	ret
    release(&pr.lock);
    80005cec:	00020517          	auipc	a0,0x20
    80005cf0:	4fc50513          	addi	a0,a0,1276 # 800261e8 <pr>
    80005cf4:	00000097          	auipc	ra,0x0
    80005cf8:	3d0080e7          	jalr	976(ra) # 800060c4 <release>
}
    80005cfc:	bfc9                	j	80005cce <printf+0x1b0>

0000000080005cfe <printfinit>:
    ;
}

void
printfinit(void)
{
    80005cfe:	1101                	addi	sp,sp,-32
    80005d00:	ec06                	sd	ra,24(sp)
    80005d02:	e822                	sd	s0,16(sp)
    80005d04:	e426                	sd	s1,8(sp)
    80005d06:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005d08:	00020497          	auipc	s1,0x20
    80005d0c:	4e048493          	addi	s1,s1,1248 # 800261e8 <pr>
    80005d10:	00003597          	auipc	a1,0x3
    80005d14:	aa858593          	addi	a1,a1,-1368 # 800087b8 <syscalls+0x3f0>
    80005d18:	8526                	mv	a0,s1
    80005d1a:	00000097          	auipc	ra,0x0
    80005d1e:	266080e7          	jalr	614(ra) # 80005f80 <initlock>
  pr.locking = 1;
    80005d22:	4785                	li	a5,1
    80005d24:	cc9c                	sw	a5,24(s1)
}
    80005d26:	60e2                	ld	ra,24(sp)
    80005d28:	6442                	ld	s0,16(sp)
    80005d2a:	64a2                	ld	s1,8(sp)
    80005d2c:	6105                	addi	sp,sp,32
    80005d2e:	8082                	ret

0000000080005d30 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005d30:	1141                	addi	sp,sp,-16
    80005d32:	e406                	sd	ra,8(sp)
    80005d34:	e022                	sd	s0,0(sp)
    80005d36:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005d38:	100007b7          	lui	a5,0x10000
    80005d3c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005d40:	f8000713          	li	a4,-128
    80005d44:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005d48:	470d                	li	a4,3
    80005d4a:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005d4e:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005d52:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005d56:	469d                	li	a3,7
    80005d58:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005d5c:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005d60:	00003597          	auipc	a1,0x3
    80005d64:	a7858593          	addi	a1,a1,-1416 # 800087d8 <digits+0x18>
    80005d68:	00020517          	auipc	a0,0x20
    80005d6c:	4a050513          	addi	a0,a0,1184 # 80026208 <uart_tx_lock>
    80005d70:	00000097          	auipc	ra,0x0
    80005d74:	210080e7          	jalr	528(ra) # 80005f80 <initlock>
}
    80005d78:	60a2                	ld	ra,8(sp)
    80005d7a:	6402                	ld	s0,0(sp)
    80005d7c:	0141                	addi	sp,sp,16
    80005d7e:	8082                	ret

0000000080005d80 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005d80:	1101                	addi	sp,sp,-32
    80005d82:	ec06                	sd	ra,24(sp)
    80005d84:	e822                	sd	s0,16(sp)
    80005d86:	e426                	sd	s1,8(sp)
    80005d88:	1000                	addi	s0,sp,32
    80005d8a:	84aa                	mv	s1,a0
  push_off();
    80005d8c:	00000097          	auipc	ra,0x0
    80005d90:	238080e7          	jalr	568(ra) # 80005fc4 <push_off>

  if(panicked){
    80005d94:	00003797          	auipc	a5,0x3
    80005d98:	2887a783          	lw	a5,648(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005d9c:	10000737          	lui	a4,0x10000
  if(panicked){
    80005da0:	c391                	beqz	a5,80005da4 <uartputc_sync+0x24>
    for(;;)
    80005da2:	a001                	j	80005da2 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005da4:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005da8:	0207f793          	andi	a5,a5,32
    80005dac:	dfe5                	beqz	a5,80005da4 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005dae:	0ff4f513          	andi	a0,s1,255
    80005db2:	100007b7          	lui	a5,0x10000
    80005db6:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005dba:	00000097          	auipc	ra,0x0
    80005dbe:	2aa080e7          	jalr	682(ra) # 80006064 <pop_off>
}
    80005dc2:	60e2                	ld	ra,24(sp)
    80005dc4:	6442                	ld	s0,16(sp)
    80005dc6:	64a2                	ld	s1,8(sp)
    80005dc8:	6105                	addi	sp,sp,32
    80005dca:	8082                	ret

0000000080005dcc <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005dcc:	00003797          	auipc	a5,0x3
    80005dd0:	2547b783          	ld	a5,596(a5) # 80009020 <uart_tx_r>
    80005dd4:	00003717          	auipc	a4,0x3
    80005dd8:	25473703          	ld	a4,596(a4) # 80009028 <uart_tx_w>
    80005ddc:	06f70a63          	beq	a4,a5,80005e50 <uartstart+0x84>
{
    80005de0:	7139                	addi	sp,sp,-64
    80005de2:	fc06                	sd	ra,56(sp)
    80005de4:	f822                	sd	s0,48(sp)
    80005de6:	f426                	sd	s1,40(sp)
    80005de8:	f04a                	sd	s2,32(sp)
    80005dea:	ec4e                	sd	s3,24(sp)
    80005dec:	e852                	sd	s4,16(sp)
    80005dee:	e456                	sd	s5,8(sp)
    80005df0:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005df2:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005df6:	00020a17          	auipc	s4,0x20
    80005dfa:	412a0a13          	addi	s4,s4,1042 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005dfe:	00003497          	auipc	s1,0x3
    80005e02:	22248493          	addi	s1,s1,546 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005e06:	00003997          	auipc	s3,0x3
    80005e0a:	22298993          	addi	s3,s3,546 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005e0e:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005e12:	02077713          	andi	a4,a4,32
    80005e16:	c705                	beqz	a4,80005e3e <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005e18:	01f7f713          	andi	a4,a5,31
    80005e1c:	9752                	add	a4,a4,s4
    80005e1e:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005e22:	0785                	addi	a5,a5,1
    80005e24:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005e26:	8526                	mv	a0,s1
    80005e28:	ffffc097          	auipc	ra,0xffffc
    80005e2c:	866080e7          	jalr	-1946(ra) # 8000168e <wakeup>
    
    WriteReg(THR, c);
    80005e30:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005e34:	609c                	ld	a5,0(s1)
    80005e36:	0009b703          	ld	a4,0(s3)
    80005e3a:	fcf71ae3          	bne	a4,a5,80005e0e <uartstart+0x42>
  }
}
    80005e3e:	70e2                	ld	ra,56(sp)
    80005e40:	7442                	ld	s0,48(sp)
    80005e42:	74a2                	ld	s1,40(sp)
    80005e44:	7902                	ld	s2,32(sp)
    80005e46:	69e2                	ld	s3,24(sp)
    80005e48:	6a42                	ld	s4,16(sp)
    80005e4a:	6aa2                	ld	s5,8(sp)
    80005e4c:	6121                	addi	sp,sp,64
    80005e4e:	8082                	ret
    80005e50:	8082                	ret

0000000080005e52 <uartputc>:
{
    80005e52:	7179                	addi	sp,sp,-48
    80005e54:	f406                	sd	ra,40(sp)
    80005e56:	f022                	sd	s0,32(sp)
    80005e58:	ec26                	sd	s1,24(sp)
    80005e5a:	e84a                	sd	s2,16(sp)
    80005e5c:	e44e                	sd	s3,8(sp)
    80005e5e:	e052                	sd	s4,0(sp)
    80005e60:	1800                	addi	s0,sp,48
    80005e62:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005e64:	00020517          	auipc	a0,0x20
    80005e68:	3a450513          	addi	a0,a0,932 # 80026208 <uart_tx_lock>
    80005e6c:	00000097          	auipc	ra,0x0
    80005e70:	1a4080e7          	jalr	420(ra) # 80006010 <acquire>
  if(panicked){
    80005e74:	00003797          	auipc	a5,0x3
    80005e78:	1a87a783          	lw	a5,424(a5) # 8000901c <panicked>
    80005e7c:	c391                	beqz	a5,80005e80 <uartputc+0x2e>
    for(;;)
    80005e7e:	a001                	j	80005e7e <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005e80:	00003717          	auipc	a4,0x3
    80005e84:	1a873703          	ld	a4,424(a4) # 80009028 <uart_tx_w>
    80005e88:	00003797          	auipc	a5,0x3
    80005e8c:	1987b783          	ld	a5,408(a5) # 80009020 <uart_tx_r>
    80005e90:	02078793          	addi	a5,a5,32
    80005e94:	02e79b63          	bne	a5,a4,80005eca <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80005e98:	00020997          	auipc	s3,0x20
    80005e9c:	37098993          	addi	s3,s3,880 # 80026208 <uart_tx_lock>
    80005ea0:	00003497          	auipc	s1,0x3
    80005ea4:	18048493          	addi	s1,s1,384 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005ea8:	00003917          	auipc	s2,0x3
    80005eac:	18090913          	addi	s2,s2,384 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80005eb0:	85ce                	mv	a1,s3
    80005eb2:	8526                	mv	a0,s1
    80005eb4:	ffffb097          	auipc	ra,0xffffb
    80005eb8:	64e080e7          	jalr	1614(ra) # 80001502 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005ebc:	00093703          	ld	a4,0(s2)
    80005ec0:	609c                	ld	a5,0(s1)
    80005ec2:	02078793          	addi	a5,a5,32
    80005ec6:	fee785e3          	beq	a5,a4,80005eb0 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005eca:	00020497          	auipc	s1,0x20
    80005ece:	33e48493          	addi	s1,s1,830 # 80026208 <uart_tx_lock>
    80005ed2:	01f77793          	andi	a5,a4,31
    80005ed6:	97a6                	add	a5,a5,s1
    80005ed8:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80005edc:	0705                	addi	a4,a4,1
    80005ede:	00003797          	auipc	a5,0x3
    80005ee2:	14e7b523          	sd	a4,330(a5) # 80009028 <uart_tx_w>
      uartstart();
    80005ee6:	00000097          	auipc	ra,0x0
    80005eea:	ee6080e7          	jalr	-282(ra) # 80005dcc <uartstart>
      release(&uart_tx_lock);
    80005eee:	8526                	mv	a0,s1
    80005ef0:	00000097          	auipc	ra,0x0
    80005ef4:	1d4080e7          	jalr	468(ra) # 800060c4 <release>
}
    80005ef8:	70a2                	ld	ra,40(sp)
    80005efa:	7402                	ld	s0,32(sp)
    80005efc:	64e2                	ld	s1,24(sp)
    80005efe:	6942                	ld	s2,16(sp)
    80005f00:	69a2                	ld	s3,8(sp)
    80005f02:	6a02                	ld	s4,0(sp)
    80005f04:	6145                	addi	sp,sp,48
    80005f06:	8082                	ret

0000000080005f08 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005f08:	1141                	addi	sp,sp,-16
    80005f0a:	e422                	sd	s0,8(sp)
    80005f0c:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005f0e:	100007b7          	lui	a5,0x10000
    80005f12:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005f16:	8b85                	andi	a5,a5,1
    80005f18:	cb91                	beqz	a5,80005f2c <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80005f1a:	100007b7          	lui	a5,0x10000
    80005f1e:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80005f22:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80005f26:	6422                	ld	s0,8(sp)
    80005f28:	0141                	addi	sp,sp,16
    80005f2a:	8082                	ret
    return -1;
    80005f2c:	557d                	li	a0,-1
    80005f2e:	bfe5                	j	80005f26 <uartgetc+0x1e>

0000000080005f30 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80005f30:	1101                	addi	sp,sp,-32
    80005f32:	ec06                	sd	ra,24(sp)
    80005f34:	e822                	sd	s0,16(sp)
    80005f36:	e426                	sd	s1,8(sp)
    80005f38:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005f3a:	54fd                	li	s1,-1
    80005f3c:	a029                	j	80005f46 <uartintr+0x16>
      break;
    consoleintr(c);
    80005f3e:	00000097          	auipc	ra,0x0
    80005f42:	916080e7          	jalr	-1770(ra) # 80005854 <consoleintr>
    int c = uartgetc();
    80005f46:	00000097          	auipc	ra,0x0
    80005f4a:	fc2080e7          	jalr	-62(ra) # 80005f08 <uartgetc>
    if(c == -1)
    80005f4e:	fe9518e3          	bne	a0,s1,80005f3e <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80005f52:	00020497          	auipc	s1,0x20
    80005f56:	2b648493          	addi	s1,s1,694 # 80026208 <uart_tx_lock>
    80005f5a:	8526                	mv	a0,s1
    80005f5c:	00000097          	auipc	ra,0x0
    80005f60:	0b4080e7          	jalr	180(ra) # 80006010 <acquire>
  uartstart();
    80005f64:	00000097          	auipc	ra,0x0
    80005f68:	e68080e7          	jalr	-408(ra) # 80005dcc <uartstart>
  release(&uart_tx_lock);
    80005f6c:	8526                	mv	a0,s1
    80005f6e:	00000097          	auipc	ra,0x0
    80005f72:	156080e7          	jalr	342(ra) # 800060c4 <release>
}
    80005f76:	60e2                	ld	ra,24(sp)
    80005f78:	6442                	ld	s0,16(sp)
    80005f7a:	64a2                	ld	s1,8(sp)
    80005f7c:	6105                	addi	sp,sp,32
    80005f7e:	8082                	ret

0000000080005f80 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005f80:	1141                	addi	sp,sp,-16
    80005f82:	e422                	sd	s0,8(sp)
    80005f84:	0800                	addi	s0,sp,16
  lk->name = name;
    80005f86:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005f88:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80005f8c:	00053823          	sd	zero,16(a0)
}
    80005f90:	6422                	ld	s0,8(sp)
    80005f92:	0141                	addi	sp,sp,16
    80005f94:	8082                	ret

0000000080005f96 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005f96:	411c                	lw	a5,0(a0)
    80005f98:	e399                	bnez	a5,80005f9e <holding+0x8>
    80005f9a:	4501                	li	a0,0
  return r;
}
    80005f9c:	8082                	ret
{
    80005f9e:	1101                	addi	sp,sp,-32
    80005fa0:	ec06                	sd	ra,24(sp)
    80005fa2:	e822                	sd	s0,16(sp)
    80005fa4:	e426                	sd	s1,8(sp)
    80005fa6:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005fa8:	6904                	ld	s1,16(a0)
    80005faa:	ffffb097          	auipc	ra,0xffffb
    80005fae:	e7c080e7          	jalr	-388(ra) # 80000e26 <mycpu>
    80005fb2:	40a48533          	sub	a0,s1,a0
    80005fb6:	00153513          	seqz	a0,a0
}
    80005fba:	60e2                	ld	ra,24(sp)
    80005fbc:	6442                	ld	s0,16(sp)
    80005fbe:	64a2                	ld	s1,8(sp)
    80005fc0:	6105                	addi	sp,sp,32
    80005fc2:	8082                	ret

0000000080005fc4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005fc4:	1101                	addi	sp,sp,-32
    80005fc6:	ec06                	sd	ra,24(sp)
    80005fc8:	e822                	sd	s0,16(sp)
    80005fca:	e426                	sd	s1,8(sp)
    80005fcc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005fce:	100024f3          	csrr	s1,sstatus
    80005fd2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005fd6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005fd8:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80005fdc:	ffffb097          	auipc	ra,0xffffb
    80005fe0:	e4a080e7          	jalr	-438(ra) # 80000e26 <mycpu>
    80005fe4:	5d3c                	lw	a5,120(a0)
    80005fe6:	cf89                	beqz	a5,80006000 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005fe8:	ffffb097          	auipc	ra,0xffffb
    80005fec:	e3e080e7          	jalr	-450(ra) # 80000e26 <mycpu>
    80005ff0:	5d3c                	lw	a5,120(a0)
    80005ff2:	2785                	addiw	a5,a5,1
    80005ff4:	dd3c                	sw	a5,120(a0)
}
    80005ff6:	60e2                	ld	ra,24(sp)
    80005ff8:	6442                	ld	s0,16(sp)
    80005ffa:	64a2                	ld	s1,8(sp)
    80005ffc:	6105                	addi	sp,sp,32
    80005ffe:	8082                	ret
    mycpu()->intena = old;
    80006000:	ffffb097          	auipc	ra,0xffffb
    80006004:	e26080e7          	jalr	-474(ra) # 80000e26 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006008:	8085                	srli	s1,s1,0x1
    8000600a:	8885                	andi	s1,s1,1
    8000600c:	dd64                	sw	s1,124(a0)
    8000600e:	bfe9                	j	80005fe8 <push_off+0x24>

0000000080006010 <acquire>:
{
    80006010:	1101                	addi	sp,sp,-32
    80006012:	ec06                	sd	ra,24(sp)
    80006014:	e822                	sd	s0,16(sp)
    80006016:	e426                	sd	s1,8(sp)
    80006018:	1000                	addi	s0,sp,32
    8000601a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000601c:	00000097          	auipc	ra,0x0
    80006020:	fa8080e7          	jalr	-88(ra) # 80005fc4 <push_off>
  if(holding(lk))
    80006024:	8526                	mv	a0,s1
    80006026:	00000097          	auipc	ra,0x0
    8000602a:	f70080e7          	jalr	-144(ra) # 80005f96 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000602e:	4705                	li	a4,1
  if(holding(lk))
    80006030:	e115                	bnez	a0,80006054 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006032:	87ba                	mv	a5,a4
    80006034:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006038:	2781                	sext.w	a5,a5
    8000603a:	ffe5                	bnez	a5,80006032 <acquire+0x22>
  __sync_synchronize();
    8000603c:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006040:	ffffb097          	auipc	ra,0xffffb
    80006044:	de6080e7          	jalr	-538(ra) # 80000e26 <mycpu>
    80006048:	e888                	sd	a0,16(s1)
}
    8000604a:	60e2                	ld	ra,24(sp)
    8000604c:	6442                	ld	s0,16(sp)
    8000604e:	64a2                	ld	s1,8(sp)
    80006050:	6105                	addi	sp,sp,32
    80006052:	8082                	ret
    panic("acquire");
    80006054:	00002517          	auipc	a0,0x2
    80006058:	78c50513          	addi	a0,a0,1932 # 800087e0 <digits+0x20>
    8000605c:	00000097          	auipc	ra,0x0
    80006060:	a78080e7          	jalr	-1416(ra) # 80005ad4 <panic>

0000000080006064 <pop_off>:

void
pop_off(void)
{
    80006064:	1141                	addi	sp,sp,-16
    80006066:	e406                	sd	ra,8(sp)
    80006068:	e022                	sd	s0,0(sp)
    8000606a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000606c:	ffffb097          	auipc	ra,0xffffb
    80006070:	dba080e7          	jalr	-582(ra) # 80000e26 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006074:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006078:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000607a:	e78d                	bnez	a5,800060a4 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000607c:	5d3c                	lw	a5,120(a0)
    8000607e:	02f05b63          	blez	a5,800060b4 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006082:	37fd                	addiw	a5,a5,-1
    80006084:	0007871b          	sext.w	a4,a5
    80006088:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000608a:	eb09                	bnez	a4,8000609c <pop_off+0x38>
    8000608c:	5d7c                	lw	a5,124(a0)
    8000608e:	c799                	beqz	a5,8000609c <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006090:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006094:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006098:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000609c:	60a2                	ld	ra,8(sp)
    8000609e:	6402                	ld	s0,0(sp)
    800060a0:	0141                	addi	sp,sp,16
    800060a2:	8082                	ret
    panic("pop_off - interruptible");
    800060a4:	00002517          	auipc	a0,0x2
    800060a8:	74450513          	addi	a0,a0,1860 # 800087e8 <digits+0x28>
    800060ac:	00000097          	auipc	ra,0x0
    800060b0:	a28080e7          	jalr	-1496(ra) # 80005ad4 <panic>
    panic("pop_off");
    800060b4:	00002517          	auipc	a0,0x2
    800060b8:	74c50513          	addi	a0,a0,1868 # 80008800 <digits+0x40>
    800060bc:	00000097          	auipc	ra,0x0
    800060c0:	a18080e7          	jalr	-1512(ra) # 80005ad4 <panic>

00000000800060c4 <release>:
{
    800060c4:	1101                	addi	sp,sp,-32
    800060c6:	ec06                	sd	ra,24(sp)
    800060c8:	e822                	sd	s0,16(sp)
    800060ca:	e426                	sd	s1,8(sp)
    800060cc:	1000                	addi	s0,sp,32
    800060ce:	84aa                	mv	s1,a0
  if(!holding(lk))
    800060d0:	00000097          	auipc	ra,0x0
    800060d4:	ec6080e7          	jalr	-314(ra) # 80005f96 <holding>
    800060d8:	c115                	beqz	a0,800060fc <release+0x38>
  lk->cpu = 0;
    800060da:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800060de:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800060e2:	0f50000f          	fence	iorw,ow
    800060e6:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800060ea:	00000097          	auipc	ra,0x0
    800060ee:	f7a080e7          	jalr	-134(ra) # 80006064 <pop_off>
}
    800060f2:	60e2                	ld	ra,24(sp)
    800060f4:	6442                	ld	s0,16(sp)
    800060f6:	64a2                	ld	s1,8(sp)
    800060f8:	6105                	addi	sp,sp,32
    800060fa:	8082                	ret
    panic("release");
    800060fc:	00002517          	auipc	a0,0x2
    80006100:	70c50513          	addi	a0,a0,1804 # 80008808 <digits+0x48>
    80006104:	00000097          	auipc	ra,0x0
    80006108:	9d0080e7          	jalr	-1584(ra) # 80005ad4 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
