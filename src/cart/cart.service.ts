import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Cart } from '../entities/cart.entity';
import { CartDetail } from '../entities/cart-detail.entity';
import { Product } from '../entities/product.entity';
import { User } from '../entities/user.entity';
import { AddProductToCartDto } from './dtos/add-product-to-cart.dto';

@Injectable()
export class CartService {
  constructor(
    @InjectRepository(Cart) private cartRepo: Repository<Cart>,
    @InjectRepository(CartDetail)
    private cartDetailRepo: Repository<CartDetail>,
    @InjectRepository(Product) private productRepo: Repository<Product>,
  ) {}

  async createCart(user: User) {
    const cart = this.cartRepo.create({ user }); // Truyền cả đối tượng user vào
    return this.cartRepo.save(cart);
  }

  async addProductToCart(addProductToCartDto: AddProductToCartDto) {
    const cart = await this.cartRepo.findOneBy({
      id: addProductToCartDto.cartId,
    });
    const product = await this.productRepo.findOneBy({
      id: addProductToCartDto.productId,
    });

    if (!cart || !product) {
      throw new Error('Cart or Product not found');
    }

    const cartDetail = this.cartDetailRepo.create({
      cart,
      product,
      quantity: addProductToCartDto.quantity,
    });

    return this.cartDetailRepo.save(cartDetail);
  }

  async getCartDetails(cartId: number) {
    return this.cartDetailRepo.find({
      where: { cart: { id: cartId } },
      relations: ['product'],
    });
  }

  async removeProductFromCart(cartDetailId: number) {
    await this.cartDetailRepo.delete(cartDetailId);
    return { message: 'Product removed from cart' };
  }

  async clearCart(cartId: number) {
    const cart = await this.cartRepo.findOne({
      where: { id: cartId },
      relations: ['cartDetails'],
    });

    if (!cart) {
      throw new Error('Cart not found');
    }

    await this.cartDetailRepo.remove(cart.cartDetails);
    return { message: 'Cart cleared' };
  }
}
