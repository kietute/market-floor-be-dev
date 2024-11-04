import { Controller, Post, Body, UseGuards, Get, Param, Patch } from '@nestjs/common';
import { OrderService } from './order.service';
import { CreateOrderDto } from './dtos/create-order.dto';
import { UpdateOrderStatusDto } from './dtos/update-order-status.dto';
import { AuthGuard } from '../common/guards/auth.guard';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { User } from '../entities/user.entity';

@Controller('orders')
export class OrderController {
  constructor(private orderService: OrderService) {}

  @Post('/create-order')
  @UseGuards(AuthGuard)
  async createOrderFromCart(@CurrentUser() user: User) {
    return this.orderService.createOrderFromCart(user);
  }
  @Patch(':orderId/status')
  async updateOrderStatus(
    @Param('orderId') orderId: number,
    @Body() updateOrderStatusDto: UpdateOrderStatusDto,
  ) {
    return this.orderService.updateOrderStatus(orderId, updateOrderStatusDto);
  }

  @Get()
  @UseGuards(AuthGuard)
  async getUserOrders(@CurrentUser() user: User) {
    return this.orderService.getUserOrders(user);
  }
}
