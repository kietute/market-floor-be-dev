import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Order } from '../entities/order.entity';
import { OrderDetail } from '../entities/order-detail.entity';
import { Product } from '../entities/product.entity';
import { UpdateOrderStatusDto } from './dtos/update-order-status.dto';
import { User } from '../entities/user.entity';
import { CartService } from '../cart/cart.service';

@Injectable()
export class OrderService {
  constructor(
    @InjectRepository(Order) private orderRepo: Repository<Order>,
    @InjectRepository(OrderDetail) private orderDetailRepo: Repository<OrderDetail>,
    @InjectRepository(Product) private productRepo: Repository<Product>,
    private cartService: CartService,
    private orderRepository: Repository<Order>,
  ) {}

  async createOrderFromCart(user: User): Promise<Order> {
    // Fetch the user's cart and cart details
    const cart = await this.cartService.getCart(user);
    if (!cart || !cart.cartDetails.length) {
      throw new NotFoundException('Cart is empty');
    }

    // Create a new order
    const order = new Order();
    order.user = user;
    order.status = 'pending';
    order.orderDetails = [];
    let totalAmount = 0;

    // Create order details based on the cart items
    for (const cartDetail of cart.cartDetails) {
      const orderDetail = new OrderDetail();
      orderDetail.product = cartDetail.product;
      orderDetail.quantity = cartDetail.quantity;
      orderDetail.price = cartDetail.product.price.price; // Assuming product price structure

      // Calculate total price for this order detail and add to total amount
      totalAmount += orderDetail.quantity * orderDetail.price;

      order.orderDetails.push(orderDetail);
    }

    // Set the total amount on the order
    order.totalAmount = totalAmount;

    // Save the order and its details
    const savedOrder = await this.orderRepo.save(order);

    // Optionally, clear the cart after order creation
    await this.cartService.clearCart(cart.id);

    return savedOrder;
  }

  async updateOrderStatus(orderId: number, updateOrderStatusDto: UpdateOrderStatusDto) {
    // Use `where` clause to find the order by ID
    const order = await this.orderRepo.findOne({ where: { id: orderId } });
    if (!order) throw new Error('Order not found');

    // Update the order status
    order.status = updateOrderStatusDto.status;
    return await this.orderRepo.save(order);
  }


  async getUserOrders(user) {
    return await this.orderRepo.find({
      where: { user },
      relations: ['orderDetails', 'orderDetails.product'],
    });
  }
}
